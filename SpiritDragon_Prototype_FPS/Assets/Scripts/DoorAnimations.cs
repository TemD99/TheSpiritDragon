using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorAnimations : MonoBehaviour
{
    [SerializeField] Animator door;

    private void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<playerController>())
            door.SetBool("character_nearby", true);
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.GetComponent<playerController>())
            door.SetBool("character_nearby", false);
    }
}
