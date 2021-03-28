%bcond_without tests
%bcond_without weak_deps

%global __os_install_post %(echo '%{__os_install_post}' | sed -e 's!/usr/lib[^[:space:]]*/brp-python-bytecompile[[:space:]].*$!!g')
%global __provides_exclude_from ^/opt/ros/noetic/.*$
%global __requires_exclude_from ^/opt/ros/noetic/.*$

Name:           ros-noetic-rtabmap
Version:        0.20.9
Release:        1%{?dist}%{?release_suffix}
Summary:        ROS rtabmap package

License:        BSD
URL:            http://introlab.github.io/rtabmap
Source0:        %{name}-%{version}.tar.gz

Requires:       libfreenect-devel
Requires:       libsq3-devel
Requires:       openni-devel
Requires:       pcl-devel
Requires:       ros-noetic-cv-bridge
Requires:       ros-noetic-libg2o
Requires:       ros-noetic-octomap
Requires:       ros-noetic-qt-gui-cpp
Requires:       zlib-devel
BuildRequires:  cmake
BuildRequires:  libfreenect-devel
BuildRequires:  libsq3-devel
BuildRequires:  openni-devel
BuildRequires:  pcl-devel
BuildRequires:  proj-devel
BuildRequires:  ros-noetic-cv-bridge
BuildRequires:  ros-noetic-libg2o
BuildRequires:  ros-noetic-octomap
BuildRequires:  ros-noetic-qt-gui-cpp
BuildRequires:  zlib-devel
Provides:       %{name}-devel = %{version}-%{release}
Provides:       %{name}-doc = %{version}-%{release}
Provides:       %{name}-runtime = %{version}-%{release}

%description
RTAB-Map's standalone library. RTAB-Map is a RGB-D SLAM approach with real-time
constraints.

%prep
%autosetup

%build
# In case we're installing to a non-standard location, look for a setup.sh
# in the install tree and source it.  It will set things like
# CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
if [ -f "/opt/ros/noetic/setup.sh" ]; then . "/opt/ros/noetic/setup.sh"; fi
mkdir -p obj-%{_target_platform} && cd obj-%{_target_platform}
%cmake3 \
    -UINCLUDE_INSTALL_DIR \
    -ULIB_INSTALL_DIR \
    -USYSCONF_INSTALL_DIR \
    -USHARE_INSTALL_PREFIX \
    -ULIB_SUFFIX \
    -DCMAKE_INSTALL_PREFIX="/opt/ros/noetic" \
    -DCMAKE_PREFIX_PATH="/opt/ros/noetic" \
    -DSETUPTOOLS_DEB_LAYOUT=OFF \
    ..

%make_build

%install
# In case we're installing to a non-standard location, look for a setup.sh
# in the install tree and source it.  It will set things like
# CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
if [ -f "/opt/ros/noetic/setup.sh" ]; then . "/opt/ros/noetic/setup.sh"; fi
%make_install -C obj-%{_target_platform}

%if 0%{?with_tests}
%check
# Look for a Makefile target with a name indicating that it runs tests
TEST_TARGET=$(%__make -qp -C obj-%{_target_platform} | sed "s/^\(test\|check\):.*/\\1/;t f;d;:f;q0")
if [ -n "$TEST_TARGET" ]; then
# In case we're installing to a non-standard location, look for a setup.sh
# in the install tree and source it.  It will set things like
# CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
if [ -f "/opt/ros/noetic/setup.sh" ]; then . "/opt/ros/noetic/setup.sh"; fi
CTEST_OUTPUT_ON_FAILURE=1 \
    %make_build -C obj-%{_target_platform} $TEST_TARGET || echo "RPM TESTS FAILED"
else echo "RPM TESTS SKIPPED"; fi
%endif

%files
/opt/ros/noetic

%changelog
* Sun Mar 28 2021 Mathieu Labbe <matlabbe@gmail.com> - 0.20.9-1
- Autogenerated by Bloom

* Sat Dec 12 2020 Mathieu Labbe <matlabbe@gmail.com> - 0.20.7-2
- Autogenerated by Bloom

* Sat Dec 12 2020 Mathieu Labbe <matlabbe@gmail.com> - 0.20.7-1
- Autogenerated by Bloom

* Mon Jun 01 2020 Mathieu Labbe <matlabbe@gmail.com> - 0.20.0-3
- Autogenerated by Bloom

* Mon Jun 01 2020 Mathieu Labbe <matlabbe@gmail.com> - 0.20.0-2
- Autogenerated by Bloom

* Sun May 31 2020 Mathieu Labbe <matlabbe@gmail.com> - 0.20.0-1
- Autogenerated by Bloom

