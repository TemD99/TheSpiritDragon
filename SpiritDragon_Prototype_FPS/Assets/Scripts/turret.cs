using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class turret : MonoBehaviour, IDamage
{
    [Header("----- Components -----")]
    [SerializeField] Renderer model;
    [SerializeField] AudioSource aud;
    [SerializeField] GameObject DedExpl;

    [Header("----- Stats -----")]
    [SerializeField] Transform headPos;
    [Range(0, 100)] [SerializeField] int Hp;
    [Range(0, 50)] [SerializeField] int playerFaceSpeed;
    [SerializeField] int viewAngle;

    [Header("----- Gun -----")]
    [SerializeField] AudioClip Shot;
    [Range(0, 1)] [SerializeField] float audShotVol;
    [SerializeField] List<Transform> barrels;
    [SerializeField] GameObject bullet;
    [SerializeField] int bulletSpeed;
    [SerializeField] float fireRate;

    [Header("-------Audio-------")]
    [SerializeField] AudioClip[] audDmg;
    [Range(0, 1)] [SerializeField] float audDmgVol;
    [SerializeField] AudioClip[] audDeath;
    [Range(0, 1)] [SerializeField] float audDeathVol;


    Vector3 plyrDir;
    bool Shooting, NRange;
    float angleToPlayer;
    int barrelNum;
    Color basic;

    // Start is called before the first frame update
    void Start()
    {
       basic = model.material.color;
    }

    // Update is called once per frame
    void Update()
    {
        if(NRange && canSeePlayer())
        {
            facePlayer();
           if(!Shooting)
                StartCoroutine(shoot());
        }
    }
     void facePlayer()
    {
        Quaternion rot = Quaternion.LookRotation(plyrDir);
        transform.rotation = Quaternion.Lerp(transform.rotation, rot, Time.deltaTime * playerFaceSpeed);
    }
    bool canSeePlayer()
    {
        plyrDir = gameManager.instance.player.transform.position - headPos.position;
        angleToPlayer = Vector3.Angle(plyrDir, transform.forward);
        RaycastHit hit;
        Debug.DrawRay(headPos.position, plyrDir);
        if (Physics.Raycast(headPos.position, plyrDir, out hit))
        {
            if (hit.collider.CompareTag("Player") && angleToPlayer <= viewAngle)
            {
                return true;
            }
        }
        return false;
    }
    public void takeDamage(int dmg)
    {
        Hp -= dmg;
        StartCoroutine(flshDmg());
        aud.PlayOneShot(audDmg[Random.Range(0, audDmg.Length)], audDmgVol);

        if (Hp <= 0)
        {
            Dead();
            Destroy(gameObject);
        }
    }

    IEnumerator flshDmg()
    {
        model.material.color = Color.red;
        yield return new WaitForSeconds(.2f);
        model.material.color = basic;
    }
    IEnumerator shoot()
    {
        Shooting = true;
        barrelNum = barrels.Count;
        for (int i = 0; i < barrelNum; i++)
        {
            aud.PlayOneShot(Shot, audShotVol);
            GameObject clone = Instantiate(bullet, barrels[i].position, bullet.transform.rotation);
            Transform bulletForm = clone.transform;
            bulletForm.transform.GetComponent<turBull>().SendBull(plyrDir);
            clone.GetComponent<Rigidbody>().velocity = transform.forward * bulletSpeed;
            aud.PlayOneShot(Shot, audShotVol);
            yield return new WaitForSeconds(fireRate / barrelNum);
        }
        Shooting = false;
    }

    public void OnTriggerEnter(Collider obj)
    {
        if (obj.CompareTag("Player"))
        {
            NRange = true;
        }
    }

    public void OnTriggerExit(Collider obj)
    {
        if (obj.CompareTag("Player"))
        {
            NRange = false;
        }
    }

    public void Dead()
    {
        Instantiate(DedExpl, transform.position, transform.rotation);
    }
}
