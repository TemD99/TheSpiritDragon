using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public int bulletDmg;
    [SerializeField] int timer;

    // Start is called before the first frame update
    void Start()
    {
        Destroy(gameObject, timer);
    }

   private void OnTriggerEnter(Collider obj)
    {
        if(obj.CompareTag("Player"))
        {
            gameManager.instance.playerScript.takeDamage(bulletDmg);
        }
        Destroy(gameObject);
    }
}
