using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraControl : MonoBehaviour
{
    //camera standard settings
    [Header("~~~~~~Camera Settings~~~~~~")]
    [SerializeField] int sensHorz;
    [SerializeField] int sensVert;
    [SerializeField] int lockVertMin;
    [SerializeField] int lockVertMax;
    [SerializeField] bool invertX;

    float xRotation;

    // Start is called before the first frame update
    void Start()
    {
        //hiding the cursor from the play area 
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void Update()
    {
        float mouseY = Input.GetAxis("Mouse Y") * Time.deltaTime * sensVert;
        float mouseX = Input.GetAxis("Mouse X") * Time.deltaTime * sensHorz;

        if (invertX)
        {
            xRotation += mouseY;
        }
        else 
        {
            xRotation -= mouseY;
        }

        //clamp for the Camera
        xRotation = Mathf.Clamp(xRotation, lockVertMin, lockVertMax);

        //camera rotation on the X and Y Axis
        transform.localRotation = Quaternion.Euler(xRotation, 0, 0);

        transform.parent.Rotate(Vector3.up * mouseX);
    }
}
