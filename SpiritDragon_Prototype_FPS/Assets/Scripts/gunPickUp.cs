using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class gunPickUp : MonoBehaviour
{
    [SerializeField] gunStats weapon;

    private void OnTriggerEnter(Collider weaponGrab)
    {
        if (weaponGrab.CompareTag("Player"))
        {
                gameManager.instance.playerScript.gunPick(weapon, "G 19");
                Destroy(gameObject);
        }
    }

    void Update()
    {
        transform.Rotate(0f, 0.3f, 0f, Space.Self);
    }

}
