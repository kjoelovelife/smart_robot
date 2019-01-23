#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
# -------------------------------------------------------------------------
# This script is part of project Turtlebot3 , ROBOTIS 
# Visit https://github.com/robotis-git/turtlebot3
# Visit http://emanual.robotis.com/docs/en/platform/turtlebot3/getting_started/
# -------------------------------------------------------------------------


if [[ `id -u` -eq 0 ]] ; then
    echo "Do not run this with sudo (do not run random things with sudo!)." ;
    exit 1 ;
fi

# Use APT install
sudo apt-get install -y \
         ros-kinetic-joy \
         ros-kinetic-teleop-twist-joy \
         ros-kinetic-teleop-twist-keyboard \
         ros-kinetic-laser-proc \
         ros-kinetic-rgbd-launch \
         ros-kinetic-depthimage-to-laserscan \
         ros-kinetic-rosserial-arduino \
         ros-kinetic-rosserial-python \
         ros-kinetic-rosserial-server \
         ros-kinetic-rosserial-client \
         ros-kinetic-rosserial-msgs \
         ros-kinetic-amcl \
         ros-kinetic-map-server \
         ros-kinetic-move-base \
         ros-kinetic-urdf \
         ros-kinetic-xacro \
         ros-kinetic-compressed-image-transport \
         ros-kinetic-rqt-image-view \
         ros-kinetic-gmapping \
         ros-kinetic-navigation \
         ros-kinetic-interactive-markers \
         ros-kinetic-rosserial-python \
         ros-kinetic-tf \
         ros-kinetic-joystick-drivers \
         ros-kinetic-image-transport \
         ros-kinetic-cv-bridge \
         ros-kinetic-vision-opencv \
         ros-kinetic-opencv3 \
         ros-kinetic-image-proc \
         python-opencv \
         libopencv-dev \
         libbullet-dev \
         libpulse-dev \
         libasound2-dev \
         build-essential \
         gstreamer-1.0-* \
         gstreamer0.10-* \
         python-gst* \
         python-pyaudio \
         python-dev \
         python-pip \
         swig

# These don't have an APT package

# Use pip to install
sudo pip install pocketsphinx

# ROS Control App : https://play.google.com/store/apps/details?id=com.robotca.ControlApp

# The following commands allow to use USB port for OpenCR without acquiring root permission.
#rosrun turtlebot3_bringup create_udev_rules




# None of this should be needed. Next time you think you need it, let me know and we figure it out. -AC
# sudo pip install --upgrade pip setuptools wheel
