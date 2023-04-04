using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrenadePickUp : MonoBehaviour
{
    public int grenAmount;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(0f, 60 * Time.deltaTime, 0f, Space.Self);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            StartCoroutine(Gren(other));
        }

    }


    IEnumerator Gren(Collider player)
    {
        gameManager.instance.playerGrenPickUpScreen.SetActive(true);
        yield return new WaitForSeconds(0.1f);
        gameManager.instance.playerGrenPickUpScreen.SetActive(false);
        player.GetComponent<playerController>().grenPack(grenAmount);
        Destroy(gameObject);
    }
}
