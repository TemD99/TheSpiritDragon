using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorFrame : MonoBehaviour
{
    [SerializeField] Animator anim;
    // Start is called before the first frame update
    void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            anim.SetBool("Open", true);
        }

    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            anim.SetBool("Open", false);
        }

    }
   
}
