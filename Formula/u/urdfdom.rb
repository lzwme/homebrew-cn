class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https:wiki.ros.orgurdf"
  url "https:github.comrosurdfdomarchiverefstags4.0.0.tar.gz"
  sha256 "9848d106dc88dc0b907d5667c09da3ca53241fbcf17e982d8c234fe3e0d6ddcc"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https:github.comHomebrewhomebrew-corepull158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26997c0d4053081f76d45134cd87539dfd05d0cef02245bbab5db3ad59691914"
    sha256 cellar: :any,                 arm64_ventura:  "e391ca4c592fdf61705574d12482f6840ccda5b21d708dc6144a3f1083feb595"
    sha256 cellar: :any,                 arm64_monterey: "fc54fd60d9e3e710f496c15a1c6e248157d43ffb221d299843d2cf59459347f9"
    sha256 cellar: :any,                 sonoma:         "90ac111dffad6f431694f55a698f0e0a255e0c6e4c9f890e146eade855416f1b"
    sha256 cellar: :any,                 ventura:        "b8ce68be69ca73092c36f7d6d0108a2b76d22914b35fc42b4e075e39a124186c"
    sha256 cellar: :any,                 monterey:       "71dd1c7b7908e5d0fbc959d660a7b8ddd73eb6b5fc5a262f35799151b5d51695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d2278edc4be70f1de0c9260a7c4340f29a74c682cea773a15b46f36e62434e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "console_bridge"
  depends_on "tinyxml2"
  depends_on "urdfdom_headers"

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <string>
      #include <urdf_parserurdf_parser.h>
      int main() {
        std::string xml_string =
          "<robot name='testRobot'>"
          "  <link name='link_0'>  "
          "  <link>               "
          "<robot>                ";
        urdf::parseURDF(xml_string);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", *shell_output("pkg-config --cflags urdfdom").chomp.split,
                    "-L#{lib}", "-lurdfdom_world",
                    "-std=c++11", "-o", "test"
    system ".test"

    (testpath"test.xml").write <<~EOS
      <robot name="test">
        <joint name="j1" type="fixed">
          <parent link="l1">
          <child link="l2">
        <joint>
        <joint name="j2" type="fixed">
          <parent link="l1">
          <child link="l2">
        <joint>
        <link name="l1">
          <visual>
            <geometry>
              <sphere radius="1.349">
            <geometry>
            <material name="">
              <color rgba="1.0 0.65 0.0 0.01" >
            <material>
          <visual>
          <inertial>
            <mass value="8.4396">
            <inertia ixx="0.087" ixy="0.14" ixz="0.912" iyy="0.763" iyz="0.0012" izz="0.908">
          <inertial>
        <link>
        <link name="l2">
          <visual>
            <geometry>
              <cylinder radius="3.349" length="7.5490">
            <geometry>
            <material name="red ish">
              <color rgba="1 0.0001 0.0 1" >
            <material>
          <visual>
        <link>
      <robot>
    EOS

    system "#{bin}check_urdf", testpath"test.xml"
  end
end