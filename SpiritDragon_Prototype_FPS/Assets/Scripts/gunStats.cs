using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu]
public class gunStats : ScriptableObject
{
    public float shootRate;
    public int shootDist;
    public int shootDamage;
    public int weaponAmmo;
    public GameObject weaponSkin;
}
