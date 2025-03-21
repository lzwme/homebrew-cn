class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https:wiki.ros.orgurdf"
  url "https:github.comrosurdfdomarchiverefstags4.0.1.tar.gz"
  sha256 "46b122c922f44ec32674a56e16fd4b5d068b53265898cbea2c3e1939ecccc62a"
  license "BSD-3-Clause"
  revision 1

  # Upstream uses Git tags (e.g. `1.0.0`) to indicate a new version. They
  # created a few releases on GitHub in the past but now they simply use tags.
  # See: https:github.comHomebrewhomebrew-corepull158963#issuecomment-1879185279
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "108b88071225f236dc04e2e6189c902e03b31be1cd8fa0d9c0653d37414fd18c"
    sha256 cellar: :any,                 arm64_sonoma:  "618b3f4019cfd53385022f5d5013bd52e7dc49ee854202eec08248e3410f4017"
    sha256 cellar: :any,                 arm64_ventura: "fc33f8045fbf5038b6c31220757525ff7a238495f3af954c78e1b6c4b9c4f55d"
    sha256 cellar: :any,                 sonoma:        "65ccd92b9505b5fcb36025705eea6e0afb58f407686fa741645b5cae9dc5fbfd"
    sha256 cellar: :any,                 ventura:       "fbd5af7974404db7c9e393a1260452fcac2075798f10910bb7f68bbb16facc12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a19abb2c31c68f0112e1d39066385fb09c50a50b3b1b56ef989fb363455198d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf978305068ebc3082801f8aa67c683d821a66f8d3cfb60712676c62df9c14e"
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