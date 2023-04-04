do -- script NewLuaBehavior 
	
	-- get reference to the script



	
		-- get reference to the script
		local bike = LUA.script;
	   
		local yawTorque = SerializedField("yawTorque", TYPE.NUMBER); --turn left right
		
	  local model = SerializedField("model", GameObject);
	  local distanceToCover = SerializedField("distanceToCover", TYPE.NUMBER);
	  local speed = SerializedField("speed", TYPE.NUMBER);
	  local startPos;
		local thrust = SerializedField("thrust", TYPE.NUMBER);
	   
		
		local glide = 0;
	 
		local thrustGlideReduction = SerializedField("thrustGlideReduction", TYPE.NUMBER);
	  
	
	
	   
	
	 
		
		
	
		--station seat gameobject (this is a serialized field, so it's shown in the unity inspector)
		local mlStationSeatObject = SerializedField("mlStationSeatObject", GameObject); --GameObject type
	
	
	
	
	
	   local leftTriggerOn = false;
	   local leftMove = false;
	   local rightMove = false;
	
	
		local mlStation = SerializedField("Station", MLStation); --this will contain our MLStation component
		local mlStationPlayerInput = nil; --this will be a UserInput object which we can use to get input from the player that comes from the station.
		local rigidbody = nil; --this will contain our Rigidbody component
	   
		
	
		
	   
	
		
		--our event for when the player is seated in the station
		local function OnSeated()
			--get the user input from the station once they have entered.
			
			mlStationPlayerInput = mlStation.GetInput();
			local currentPlayer = mlStation.GetPlayer();
    
			-- call request ownership if this script is running in the client of player who is in the station
			
			if currentPlayer.isLocal then
			  bike.gameObject.RequestOwnership();
			end
			 --this returns a UserInput object.
		end
	
		--our event for when the player leaves the station
		local function OnLeft()
			--when the player leaves, we won't have acess to their input so we need to make this nil.
			mlStationPlayerInput = nil;
		   
			
			
			
			
		end
	
		local function LeftControl()
			--make sure that player input is not nil, which means that there is a player in the station
			if (mlStationPlayerInput ~= nil ) then
				--we will create a local variable that will store the joystick input of the left controller.
				local input_leftControl = mlStationPlayerInput.LeftControl; --Vector2 type
	
				--this will be used to make sure that the player is moving the joystick in a specific direction and not be triggered accidentally if they aren't moving it.
				local deadzoneThreshold = 0.5;      
	
				--define some vectors that we will use to move the bike.
				--and we will also multiply these vectors by our adjustable velocity and angular velocity fields.
			  
	
				--if the user pushes the joystick to the right
				if input_leftControl.x > deadzoneThreshold  then
					
					--turn the bike to the right
	
				  
				   
				   
				   -- rigidbody.AddRelativeForce(Vector3.right * input_leftControl.x * sideThrust * Time.deltaTime);
				   
	
				elseif input_leftControl.x < -deadzoneThreshold  then
					
					--turn the bike to the left
	
				   
					
					
				  --  rigidbody.AddRelativeForce(-Vector3.right * -input_leftControl.x * sideThrust * Time.deltaTime);
					
				elseif input_leftControl.y > deadzoneThreshold  then
					
					--move the bike forward
				   
					--set the velocity (positional) of the bike rigidbody to move forward
					rigidbody.AddRelativeForce(Vector3.forward * input_leftControl.y * thrust * Time.deltaTime);
					glide = thrust;
	
				elseif input_leftControl.y < -deadzoneThreshold  then
					
				   
					--set the velocity (positional) of the bike rigidbody to move forward
					rigidbody.AddRelativeForce(-Vector3.forward * -input_leftControl.y * thrust * Time.deltaTime);
					glide = thrust;
				   
				else
					
					rigidbody.AddRelativeForce(Vector3.forward * glide * Time.deltaTime);
				   glide = glide * thrustGlideReduction;
	
				end
				
			end
		end
	
		local function RightControl()
			--make sure that player input is not nil, which means that there is a player in the station
			if (mlStationPlayerInput ~= nil ) then
				--we will create a local variable that will store the joystick input of the left controller.
				local input_RightControl = mlStationPlayerInput.RightControl; --Vector2 type
				
				--this will be used to make sure that the player is moving the joystick in a specific direction and not be triggered accidentally if they aren't moving it.
				local deadzoneThreshold = 0.5;      
	
			   
	
				--if the user pushes the joystick to the right
				if input_RightControl.x > deadzoneThreshold  then
					
					--turn the bike to the right
					--bike.gameObject.transform.Rotate(Vector3.up * yawTorque * Time.deltaTime);
					--set the velocity (positional) of the bike rigidbody to move forward * Time.deltaTime);
					rigidbody.AddRelativeTorque(Vector3.down * -input_RightControl.x * yawTorque * Time.deltaTime);
					--set the velocity (positional) of the bike rigidbody to move forward
					--rigidbody.velocity = forceVector_turning_forward;
	
					--set the angular velocity (rotational) of the bike rigidbody to turn to the right
					--rigidbody.angularVelocity = forceVector_right;
	
				elseif input_RightControl.x < -deadzoneThreshold  then
					
					--turn the bike to the left
					--bike.gameObject.transform.Rotate(Vector3.down * yawTorque * Time.deltaTime);
					rigidbody.AddRelativeTorque(Vector3.up * input_RightControl.x * yawTorque * Time.deltaTime);
					--set the velocity (positional) of the bike rigidbody to move forward
					--rigidbody.velocity = forceVector_turning_forward;
	
					--set the angular velocity (rotational) of the bike rigidbody to turn to the left
					--rigidbody.angularVelocity = forceVector_left;
	
				elseif input_RightControl.y > deadzoneThreshold  then
					
					--move the bike forward
				    --rigidbody.AddRelativeTorque(Vector3.right * -input_RightControl.y * pitchTorque * Time.deltaTime);
					--set the velocity (positional) of the bike rigidbody to move forward
					--rigidbody.velocity = forceVector_forward;
	
				elseif input_RightControl.y < -deadzoneThreshold  then
					
					--move the bike backward
					--rigidbody.AddRelativeTorque(Vector3.left * input_RightControl.y * pitchTorque * Time.deltaTime);
					--set the velocity (positional) of the bike rigidbody to move backward
					--rigidbody.velocity = forceVector_back;
				else
					
				   
	
				end
				
			end
		end
		local function LeftStationMove()
		   
			CoroutineTools.WaitForSeconds(1);
			leftMove = false;
			
		end
	
		local function RightStationMove()
		   
			CoroutineTools.WaitForSeconds(1);
			rightMove = false;
			
		end
	   
	
		
		
	
		
	
		local function LeftSecondaryDownTwo()
			if (mlStationPlayerInput ~= nil ) then
		 local input_LeftSecondary = mlStationPlayerInput.LeftSecondary;
		 if input_LeftSecondary == true and leftTriggerOn == true then
		 
		  mlStationSeatObject.transform.Translate(Vector3(0,0.1,0));
		 
		 end
		end
		end
		local function LeftPrimaryDownTwo()
			if (mlStationPlayerInput ~= nil ) then
				
		 local input_LeftPrimary = mlStationPlayerInput.LeftPrimary;
		 if input_LeftPrimary == true and  leftTriggerOn == true then
			
			mlStationSeatObject.transform.Translate(Vector3(0,-0.1,0));
			
	
		 end
		end
		end
	
		
	
		
	
	   
		local function LeftTriggerDown()
			if (mlStationPlayerInput ~= nil) then
		 local input_LeftTrigger = mlStationPlayerInput.LeftTrigger;
		 if input_LeftTrigger > 0.8  then
			leftTriggerOn = true;
		 else
			leftTriggerOn = false;
		 end
		end
		end
	
		
	
		
	
		local function LeftGrabMoveLeft()
			if (mlStationPlayerInput ~= nil and leftTriggerOn == true) then
		 local input_LeftGrab = mlStationPlayerInput.LeftGrab;
		 if input_LeftGrab > 0 and leftMove == false then
			leftMove = true;
			mlStationSeatObject.transform.Translate(Vector3(-0.1,0,0));
			bike.StartCoroutine(LeftStationMove);
	
		 end
		end
		end
	
		local function RightGrabMoveRight()
			if (mlStationPlayerInput ~= nil and leftTriggerOn == true) then
		 local input_RightGrab = mlStationPlayerInput.RightGrab;
		 if input_RightGrab > 0 and  rightMove == false then
			rightMove = true;
			mlStationSeatObject.transform.Translate(Vector3(0.1,0,0));
			bike.StartCoroutine(RightStationMove);
		 end
		end
		end
	
		-- start only called at beginning
		function bike.Start()
			--using the serialized gameobject field we defined,
		   
			startPos = model.transform.localPosition;
		   
			--add our event handler functions for when the player enters and leaves the station
			mlStation.OnPlayerSeated.Add(OnSeated);
			mlStation.OnPlayerLeft.Add(OnLeft);
	
			--get our rigidbody component from the vehicle (should be on the same gameobject as our current lua script is on)
			rigidbody = bike.gameObject.GetComponent(Rigidbody);
		end
	
	
		-- update called every frame
		function bike.Update()
			
	
			
			local v = startPos;
			v.y = distanceToCover * Mathf.Sin(Time.time * speed);
			model.transform.localPosition = v;
			
		  
			--create a rotation that is looking towards the front of the bike.
			--local desiredStationRotation = Quaternion.LookRotation(bike.gameObject.transform.forward, bike.gameObject.transform.up); --Quaternion type
		   -- desiredStationRotation.x = 0; --force this axis to be zero.
			--desiredStationRotation.z = 0; --force this axis to be zero.
	
			--set the rotation of the seat to be our defined seat rotation.
		   -- mlStationSeatObject.transform.rotation = desiredStationRotation;
		  
		   LeftControl();
		   RightControl();
		   LeftSecondaryDownTwo();
		   LeftPrimaryDownTwo();
		   
		   
		   LeftTriggerDown();
		   LeftGrabMoveLeft();
		   RightGrabMoveRight();
		  
		  
		   
		  
		end
	end
	
	
	
	

    
