using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthPack : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        transform.Rotate(0f, 60 *Time.deltaTime, 0f, Space.Self);
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            StartCoroutine(health());
            other.GetComponent<playerController>().healthPack(50);
        }
    }

    IEnumerator health()
    {   
        gameManager.instance.playerHealthPickUpScreen.SetActive(true);
        yield return new WaitForSeconds(0.1f);
        gameManager.instance.playerHealthPickUpScreen.SetActive(false);
        Destroy(gameObject);
    }
}
