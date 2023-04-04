using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimationControls : MonoBehaviour
{
    [SerializeField] GameObject playerCharacter;
    [SerializeField] Animator animes;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        PlayerWalking();

    }
    public void PlayerWalking()
    {
        if (Input.GetButtonDown("Vertical"))
        {
            playerCharacter.GetComponent<Animator>().Play("Walk");
        }
        else if (Input.GetButtonUp("Vertical"))
        {
            playerCharacter.GetComponent<Animator>().Play("Idle");
        }
    }

    public void PlayerJumping()
    {
        if (Input.GetButtonDown("Jump"))
        {
            animes.SetBool("Jump", true);
        }
        if (Input.GetButtonUp("Jump"))
        {
            animes.SetBool("Jump", false);
        }
    }
}
