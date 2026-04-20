class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://ghfast.top/https://github.com/ros/urdfdom/archive/refs/tags/5.1.2.tar.gz"
  sha256 "f51e2f92a0830c41f98d5196ba5b01d2c7b900498a8c5ba767b7eb8a76852cdd"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ffb54921c4319edb52bad3ba978c39fdabf3816c3fab62d16287961c76149a58"
    sha256 cellar: :any,                 arm64_sequoia: "97f4e64eeb63e8d011bbe44216ec7b512ea76f74e0fe7ff22e459fc6190b9608"
    sha256 cellar: :any,                 arm64_sonoma:  "4a8325296f4f8af687f8e2d65012bd562406fc38f173502bdedeb6430677ec22"
    sha256 cellar: :any,                 sonoma:        "739465401662eeba5117037bc64fccbe89f3c5bc0e49965ada5b6ce03d0e6b3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ae711fbd6d50a21b673d1652b1eac7db5dba75bc004214290e4a63b2d7e635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3718e704b4e66d2e99d20e961405d4f99d0e6483088df86fd4183fec31208d17"
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