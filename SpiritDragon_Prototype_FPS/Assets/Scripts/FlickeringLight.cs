using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class FlickeringLight : MonoBehaviour
{

    [SerializeField] Light lightt;
   
    [SerializeField] float minIntensity = 0f;

    [SerializeField] float maxIntensity = 1f;

    [SerializeField] float increaseDecreasAmount;

    bool up;
    
   
    void Start()
    {
      
        if (lightt == null)
        {
            lightt = GetComponent<Light>();
        }
    }

    void Update()
    {

       
        if (lightt == null)
        {
            return;
        }

        if (lightt.intensity > maxIntensity)
        {
            up = false;
        }

        if (lightt.intensity <= minIntensity)
        {
            up = true;
        }


        if (up == true)
        {
            lightt.intensity += increaseDecreasAmount;
        }
        else
        {
            lightt.intensity -= increaseDecreasAmount;
        }

       
    }

}