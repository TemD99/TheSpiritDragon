using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;

//using UnityEditor.Experimental.Rendering;
using UnityEngine;
using UnityEngine.UI;

public class playerController : MonoBehaviour
{
    [Header("~~~~~~~Componets~~~~~~~~")]
    [SerializeField] CharacterController controller;
    [SerializeField] AudioSource aud;


    [Header("~~~~~~Player Stats~~~~~~")]
    [Range(0, 10)][SerializeField] float playerSpeed;
    [Range(1.5f, 6)][SerializeField] float playerSprintSpeed;
    [Range(0, 100)][SerializeField] int HP;
    [Range(0, 10)][SerializeField] int jumpTimes;
    [Range(0, 100)][SerializeField] int jumpSpeed;
    [Range(0, 100)][SerializeField] int gravity;
    [Range(1, 5)][SerializeField] int pushbackResTime;

    [Header("~~~~~~~Gun Stats~~~~~~~~")]
    [SerializeField] List<gunStats> weaponList = new List<gunStats>();
    [SerializeField] float shootRate;
    [SerializeField] int shootDist;
    [SerializeField] int shootDamage;
    [SerializeField] float weaponZoomMax;
    [SerializeField] GameObject weaponModel;

    [SerializeField] public int weaponAmmo;
    [SerializeField] public int Grenades;

    [Header("-------Grenade-------")]
    [SerializeField] float grenTimer;
    [SerializeField] int blastRadius;
    [SerializeField] int throwSpeed;
    [SerializeField] GameObject gren;
    [SerializeField] GameObject exp;
    [SerializeField] Transform throwPos;

    [Header("-------Audio-------")]
    [SerializeField] AudioClip[] audJump;
    [Range(0, 1)][SerializeField] float audJumpVol;
    [SerializeField] AudioClip[] audSteps;
    [Range(0, 1)][SerializeField] float audStepsVol;
    [SerializeField] AudioClip[] audDmg;
    [Range(0, 1)][SerializeField] float audDmgVol;
    [SerializeField] AudioClip[] audGunShot;
    [Range(0, 1)][SerializeField] float audGunVol;

    Vector3 move;
    Vector3 playerVelocity;
    Vector3 pushBack;
    float wepZoomOrg;
    int jumpCurrent;
    int HPorg;
    int selectedWeapon;
    public bool isShooting;
    public bool isSprinting;
    bool isPlayingSteps;
    int firstGunPickup = 0;


    // Start is called before the first frame update
    void Start()
    {
        HPorg = HP;
        wepZoomOrg = Camera.main.fieldOfView;
        stolenHealth();
    }

    // Update is called once per frame
    void Update()
    {
        pushBack = Vector3.Lerp(pushBack, Vector3.zero, Time.deltaTime * pushbackResTime);
        StartCoroutine(throwGrenade());
        movement();
        sprint();
        selectFirearm();
        if (!isShooting && weaponList.Count > 0 && Input.GetButton("Shoot") && weaponAmmo > 0)
        {
            StartCoroutine(shoot());
        }
        if (weaponAmmo <= 0)
        {
            weaponAmmo = 0;
        }
    }

    void movement()
    {
        if (controller.isGrounded && playerVelocity.y < 0)
        {
            playerVelocity.y = 0;
            jumpCurrent = 0;
        }
        move = ((transform.right * Input.GetAxis("Horizontal") + (transform.forward * Input.GetAxis("Vertical"))));
        move = move.normalized;
        controller.Move(move * Time.deltaTime * playerSpeed);
        if (Input.GetButtonDown("Jump") && jumpCurrent < jumpTimes)
        {
            jumpCurrent++;
            playerVelocity.y = jumpSpeed;
            aud.PlayOneShot(audJump[Random.Range(0, audJump.Length)], audJumpVol);
        }
        playerVelocity.y -= gravity * Time.deltaTime;
        controller.Move((playerVelocity + pushBack) * Time.deltaTime);
        if (controller.isGrounded && move.normalized.magnitude > 0.5f && !isPlayingSteps)
        {
            StartCoroutine(playSteps());
        }
    }

    IEnumerator playSteps()
    {
        isPlayingSteps = true;
        aud.PlayOneShot(audSteps[Random.Range(0, audSteps.Length)], audStepsVol);
        if (isSprinting)
        {
            yield return new WaitForSeconds(0.3f);
        }
        else
        {
            yield return new WaitForSeconds(0.5f);
        }
        isPlayingSteps = false;
    }

    void sprint()
    {
        if (Input.GetButtonDown("Sprint"))
        {
            isSprinting = true;
            playerSpeed *= playerSprintSpeed;
        }
        else if (Input.GetButtonUp("Sprint"))
        {
            isSprinting = false;
            playerSpeed /= playerSprintSpeed;
        }
    }

    IEnumerator shoot()
    {
        isShooting = true;
        aud.PlayOneShot(audGunShot[Random.Range(0, audGunShot.Length)], audGunVol);
        weaponAmmo--;
        RaycastHit hit;
        if (Physics.Raycast(Camera.main.ViewportPointToRay(new Vector2(0.5f, 0.5f)), out hit, shootDist))
        {
            Debug.Log(hit.collider.name);

            if (hit.collider.GetComponent<IDamage>() != null)
            {
                hit.collider.GetComponent<IDamage>().takeDamage(shootDamage);
            }
        }
        yield return new WaitForSeconds(shootRate);
        isShooting = false;
    }

    public void takeDamage(int dmg)
    {
        HP -= dmg;
        stolenHealth();
        StartCoroutine(youBeenShoot());
        aud.PlayOneShot(audDmg[Random.Range(0, audDmg.Length)], audDmgVol);
        if (HP <= 0)
        {
            gameManager.instance.playerDead();
        }
    }

    public void stolenHealth()
    {
        gameManager.instance.playerHpBar.fillAmount = (float)HP / (float)HPorg;
    }

    IEnumerator youBeenShoot()
    {
        gameManager.instance.playerDamageFlashScreen.SetActive(true);
        yield return new WaitForSeconds(0.1f);
        gameManager.instance.playerDamageFlashScreen.SetActive(false);
    }
    //for when we add health, weapons, and ammo. *do not erase*
    public void healthPack(int heals)
    {
        HP += heals;
        stolenHealth();
    }

    public void ammoPack(int rounds)
    {
        weaponAmmo += rounds;
    }

    public void grenPack(int nades)
    {
        Grenades += nades;
    }

    public void gunPick(gunStats gunStats, string gunName)
    {
        weaponList.Add(gunStats);
        shootRate = gunStats.shootRate;
        shootDist = gunStats.shootDist;
        shootDamage = gunStats.shootDamage;
        weaponAmmo = gunStats.weaponAmmo;

        weaponModel.GetComponentInChildren<MeshFilter>().sharedMesh = weaponList[selectedWeapon].weaponSkin.GetComponent<MeshFilter>().sharedMesh;
        weaponModel.GetComponentInChildren<MeshRenderer>().sharedMaterial = weaponList[selectedWeapon].weaponSkin.GetComponent<MeshRenderer>().sharedMaterial;
        selectedWeapon = weaponList.Count - 1;


        if (weaponModel.GetComponent<MeshFilter>().mesh.name == "shotgun2 Instance")
        {
            Vector3 newPos = new Vector3(1.33f, -1.58f, 3.8f);
            weaponModel.transform.localPosition = newPos;
        }
        if (weaponModel.GetComponent<MeshFilter>().mesh.name == "pistol3 Instance")
        {
            Vector3 newPos = new Vector3(0.57f, -0.95f, 1.83f);
            weaponModel.transform.localPosition = newPos;
        }
        if (weaponModel.GetComponent<MeshFilter>().mesh.name == "assault4 Instance")
        {
            Vector3 newPos = new Vector3(1.33f, -1.58f, 3.8f);
            weaponModel.transform.localPosition = newPos;
        }
        UpdateGunUI(selectedWeapon, firstGunPickup);
        ++firstGunPickup;
    }

    public void UpdateGunUI(int GunPos, int condition = 0)
    {
        if (weaponList[GunPos].shootDamage == 5 && condition == 0)
        {
            gameManager.instance.CurrentGunImagePistol.enabled = true;
            gameManager.instance.CurrentGunImageShotgun.enabled = false;
            gameManager.instance.CurrentGunImageAssaultRifle.enabled = false;
        }
        else if (weaponList[GunPos].shootDamage == 25 && condition == 0)
        {
            gameManager.instance.CurrentGunImagePistol.enabled = false;
            gameManager.instance.CurrentGunImageShotgun.enabled = true;
            gameManager.instance.CurrentGunImageAssaultRifle.enabled = false;
        }
        else if (weaponList[GunPos].shootDamage == 10 && condition == 0)
        {
            gameManager.instance.CurrentGunImagePistol.enabled = false;
            gameManager.instance.CurrentGunImageShotgun.enabled = false;
            gameManager.instance.CurrentGunImageAssaultRifle.enabled = true;
        }


    }

    void selectFirearm()
    {
        if (Input.GetAxis("Mouse ScrollWheel") > 0 && selectedWeapon < weaponList.Count - 1)
        {
            selectedWeapon++;
            changeFirearm();
        }
        else if (Input.GetAxis("Mouse ScrollWheel") < 0 && selectedWeapon > 0)
        {
            selectedWeapon--;
            changeFirearm();
        }
    }

    void changeFirearm()
    {
        shootRate = weaponList[selectedWeapon].shootRate;
        shootDist = weaponList[selectedWeapon].shootDist;
        shootDamage = weaponList[selectedWeapon].shootDamage;

        UpdateGunUI(selectedWeapon);


        weaponModel.GetComponentInChildren<MeshFilter>().sharedMesh = weaponList[selectedWeapon].weaponSkin.GetComponentInChildren<MeshFilter>().sharedMesh;
        weaponModel.GetComponentInChildren<MeshRenderer>().sharedMaterial = weaponList[selectedWeapon].weaponSkin.GetComponentInChildren<MeshRenderer>().sharedMaterial;
        if (weaponModel.GetComponent<MeshFilter>().mesh.name == "shotgun2 Instance")
        {

            Vector3 newPos = new Vector3(1.33f, -1.58f, 3.8f);
            weaponModel.transform.localPosition = newPos;
        }
        if (weaponModel.GetComponent<MeshFilter>().mesh.name == "pistol3 Instance")
        {
            Vector3 newPos = new Vector3(0.57f, -0.95f, 1.83f);
            weaponModel.transform.localPosition = newPos;

        }

        if (weaponModel.GetComponent<MeshFilter>().mesh.name == "assault4 Instance")
        {
            Vector3 newPos = new Vector3(1.33f, -1.58f, 3.8f);
            weaponModel.transform.localPosition = newPos;

        }
    }

    public void Spawner()
    {
        controller.enabled = false;
        transform.position = gameManager.instance.playerSpwanPOS.transform.position;

        HP = HPorg;
        stolenHealth();

        controller.enabled = true;
    }
    public void WeaponCameraFocus()
    {
        if (Input.GetButton("Zoom"))
        {
            Camera.main.fieldOfView = Mathf.Lerp(Camera.main.fieldOfView, weaponZoomMax, Time.deltaTime * 3);
        }
        else if (Camera.main.fieldOfView <= wepZoomOrg)
        {
            Camera.main.fieldOfView = Mathf.Lerp(Camera.main.fieldOfView, wepZoomOrg, Time.deltaTime * 6);

        }
    }
    public void PushBackDir(Vector3 dir)
    {
        pushBack += dir;
    }

    IEnumerator throwGrenade()
    {
        if (Input.GetButtonDown("Grenade") && Grenades > 0)
        {
            Grenades--;
            GameObject grenadeClone = Instantiate(gren, throwPos.position, gren.transform.rotation);
            grenadeClone.GetComponent<Rigidbody>().velocity = ((Camera.main.transform.forward * throwSpeed) + new Vector3(0, .5f, 0) * throwSpeed);
            yield return new WaitForSeconds(grenTimer);
            GameObject explosion = Instantiate(exp, grenadeClone.transform.position, grenadeClone.transform.rotation);
            explosion.GetComponent<SphereCollider>().radius = blastRadius;
            Destroy(grenadeClone);
            Destroy(explosion, (float).5);
        }
    }
}
