/*
Copyright (c) 2010-2016, Mathieu Labbe - IntRoLab - Universite de Sherbrooke
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Universite de Sherbrooke nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#pragma once

#include "rtabmap/core/RtabmapExp.h" // DLL export/import defines

#include <opencv2/highgui/highgui.hpp>
#include "rtabmap/core/SensorData.h"
#include "rtabmap/core/CameraInfo.h"
#include <set>
#include <stack>
#include <list>
#include <vector>

class UDirectory;
class UTimer;

namespace rtabmap
{

/**
 * Class Camera
 *
 */
class RTABMAP_EXP Camera
{
public:
	virtual ~Camera();
	SensorData takeImage(CameraInfo * info = 0);

	virtual bool init(const std::string & calibrationFolder = ".", const std::string & cameraName = "") = 0;
	virtual bool isCalibrated() const = 0;
	virtual std::string getSerial() const = 0;
	virtual bool odomProvided() const { return false; }

	//getters
	float getImageRate() const {return _imageRate;}
	const Transform & getLocalTransform() const {return _localTransform;}

	//setters
	void setImageRate(float imageRate) {_imageRate = imageRate;}
	void setLocalTransform(const Transform & localTransform) {_localTransform= localTransform;}

	void resetTimer();
protected:
	/**
	 * Constructor
	 *
	 * @param imageRate : image/second , 0 for fast as the camera can
	 */
	Camera(float imageRate = 0, const Transform & localTransform = Transform::getIdentity());

	/**
	 * returned rgb and depth images should be already rectified if calibration was loaded
	 */
	virtual SensorData captureImage(CameraInfo * info = 0) = 0;

	int getNextSeqID() {return ++_seq;}

private:
	float _imageRate;
	Transform _localTransform;
	cv::Size _targetImageSize;
	UTimer * _frameRateTimer;
	int _seq;
};


} // namespace rtabmap
