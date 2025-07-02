class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https:wiki.ros.orgurdf"
  url "https:github.comrosurdfdomarchiverefstags5.0.1.tar.gz"
  sha256 "1f610c9acd8319b9cf74ec1b1311a90c6021daa0bed23315dc714af618eaec87"
  license "BSD-3-Clause"

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https:github.comHomebrewhomebrew-corepull158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd4a8fdda41fc71917d00cffb081ec3446a3bd2019f0650a2320213d4ce291a6"
    sha256 cellar: :any,                 arm64_sonoma:  "c07c6ceda1aaa046ced881402af6b8464b68d894558e905d1763882ce4c14908"
    sha256 cellar: :any,                 arm64_ventura: "135da4ada83322c2e8fd0fef17111950e41b4c80408d73343356d0c5d7a357b2"
    sha256 cellar: :any,                 sonoma:        "c60e9daa0bcfd7b048823ce2c97933291dd58bd576e1f951b2be722a1699f7ee"
    sha256 cellar: :any,                 ventura:       "33c07de87ca188ad24a22d597b15a00ac1dd7095b2a6283f211b03b3e2951763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a23a236200d3a8a831d6151c4c8528705a925a807f9e4a2eb751477a27b2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263fcbbdbaa7cf4d2b9f0188aeb12659bf9e06910ec9a11479bf8ea5a2d3d12b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "console_bridge"
  depends_on "tinyxml2"
  depends_on "urdfdom_headers"

  # Support urdfdom_headers 2.0, upstream pr ref, https:github.comrosurdfdompull221
  patch do
    url "https:github.comrosurdfdomcommit9c5b7561612a3250f632b500ac97251ba98ece13.patch?full_index=1"
    sha256 "6c671176ab0938f81027beb6626e970e8239ecc846328661a11452dc9762bc12"
  end

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", *shell_output("pkg-config --cflags urdfdom").chomp.split,
                    "-L#{lib}", "-lurdfdom_world",
                    "-std=c++11", "-o", "test"
    system ".test"

    (testpath"test.xml").write <<~XML
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
    XML

    system bin"check_urdf", testpath"test.xml"
  end
end