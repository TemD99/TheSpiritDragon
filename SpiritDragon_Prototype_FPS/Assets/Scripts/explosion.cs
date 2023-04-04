using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class explosion : MonoBehaviour
{
    [SerializeField] int knockBack;
    [SerializeField] bool push;
    [SerializeField] int blastRadius;
    [SerializeField] int grenDmg;
    private void OnTriggerEnter(Collider other)
    {
        checkForEnemies();
    }
    void checkForEnemies()
    {

        Collider[] colliders = Physics.OverlapSphere(transform.position, blastRadius);
        foreach (Collider c in colliders)
        {
            Debug.Log(c);
            if (c.GetComponent<EnemyAI>())
            {
                c.GetComponent<EnemyAI>().takeDamage(grenDmg);
            }
            else if (c.GetComponent<turret>())
            {
                c.GetComponent<turret>().takeDamage(grenDmg);
                
            }
            else if(c.GetComponent<playerController>())
            {
                if (!push)
                    gameManager.instance.playerScript.PushBackDir((transform.position - gameManager.instance.player.transform.position).normalized * knockBack);
                else
                    gameManager.instance.playerScript.PushBackDir((gameManager.instance.player.transform.position - transform.position).normalized * knockBack);
            }
        }
    }
}
