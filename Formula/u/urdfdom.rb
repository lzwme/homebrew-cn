class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://ghfast.top/https://github.com/ros/urdfdom/archive/refs/tags/5.1.1.tar.gz"
  sha256 "e71c0249f61b184b5e157b7b406fbb354371e9bb79cd9c43431bed5ede470b46"
  license "BSD-3-Clause"
  compatibility_version 1

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https://github.com/Homebrew/homebrew-core/pull/158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52634920d1ba7da30c76be54b5df0bec3baa8affddbfb3e6911100d2c0637f48"
    sha256 cellar: :any,                 arm64_sequoia: "6954f78ab041d7b8eaabef93804410aaffc62378746c274431d35c119b5b2b85"
    sha256 cellar: :any,                 arm64_sonoma:  "5a944169b43e063bee25d0c80f3dd687c39b80a874c3987f6763d2d6635e17f0"
    sha256 cellar: :any,                 sonoma:        "21f407749aff91dbde5a62202db619f751e71b6aef0637c81f552087f384e10a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8e8b2ffe4fd723783535b2cce9c67cbed5433a72012c0ace9783c3df08820c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83041c578255ccff4c5b211aaabe49a9166265d2c878170665005f3401cfa4d7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "console_bridge"
  depends_on "tinyxml2"
  depends_on "urdfdom_headers"

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <urdf_parser/urdf_parser.h>
      int main() {
        std::string xml_string =
          "<robot name='testRobot'>"
          "  <link name='link_0'>  "
          "  </link>               "
          "</robot>                ";
        urdf::parseURDF(xml_string);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", *shell_output("pkg-config --cflags urdfdom").chomp.split,
                    "-L#{lib}", "-lurdfdom_world",
                    "-std=c++11", "-o", "test"
    system "./test"

    (testpath/"test.xml").write <<~XML
      <robot name="test">
        <joint name="j1" type="fixed">
          <parent link="l1"/>
          <child link="l2"/>
        </joint>
        <joint name="j2" type="fixed">
          <parent link="l1"/>
          <child link="l2"/>
        </joint>
        <link name="l1">
          <visual>
            <geometry>
              <sphere radius="1.349"/>
            </geometry>
            <material name="">
              <color rgba="1.0 0.65 0.0 0.01" />
            </material>
          </visual>
          <inertial>
            <mass value="8.4396"/>
            <inertia ixx="0.087" ixy="0.14" ixz="0.912" iyy="0.763" iyz="0.0012" izz="0.908"/>
          </inertial>
        </link>
        <link name="l2">
          <visual>
            <geometry>
              <cylinder radius="3.349" length="7.5490"/>
            </geometry>
            <material name="red ish">
              <color rgba="1 0.0001 0.0 1" />
            </material>
          </visual>
        </link>
      </robot>
    XML

    system bin/"check_urdf", testpath/"test.xml"
  end
end