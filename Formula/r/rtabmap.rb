class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https:introlab.github.iortabmap"
  url "https:github.comintrolabrtabmaparchiverefstags0.21.4.tar.gz"
  sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comintrolabrtabmap.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "cc57b0d9b3d57e58dccbbbdae82f3b39b6683113bae7caa46f37dd8a755d78f5"
    sha256                               arm64_ventura:  "74a9779d8d9ebcb505b69e4188f0f755355f1a729b228535e144e16a611f35b9"
    sha256                               arm64_monterey: "ec4bfeb29d09e8aa05f7ef35dba90240a377a15967fb8752a367c2db0efcc17e"
    sha256                               sonoma:         "eb0050b7b48dcfce123a231e3e04b842ae34a64c14091ec3311bdfa847818ee2"
    sha256                               ventura:        "f20a9fb35a09a629d4f3626d939ec5424a9c1cfc8fedd07f1b4a74d9d890ddbd"
    sha256                               monterey:       "eac85bc461651d072be09535e1cb5707cc94519d7b64157b9123d550dfa19caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb18e1a4921e4da2d4a0538e3ff916c33440fe36b55c0932f0e336ac266f6df"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace reference to OpenCV's Cellar path
    opencv = Formula["opencv"]
    inreplace lib.glob("rtabmap-*RTABMap_coreTargets.cmake"), opencv.prefix.realpath, opencv.opt_prefix
  end

  test do
    output = if OS.linux?
      # Linux CI cannot start windowed applications due to Qt plugin failures
      shell_output("#{bin}rtabmap-console --version")
    else
      shell_output("#{bin}rtabmap --version")
    end
    assert_match "RTAB-Map:               #{version}", output

    # Required to avoid missing Xcode headers
    # https:github.comHomebrewhomebrew-corepull162576files#r1489824628
    ENV.delete "CPATH" if OS.mac? && MacOS::CLT.installed?

    rtabmap_dir = lib"rtabmap-#{version.major_minor}"
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.10)
      project(test)
      find_package(RTABMap REQUIRED COMPONENTS core)
      add_executable(test test.cpp)
      target_link_libraries(test rtabmap::core)
    EOS
    (testpath"test.cpp").write <<~EOS
      #include <rtabmapcoreRtabmap.h>
      #include <stdio.h>
      int main()
      {
        rtabmap::Rtabmap rtabmap;
        printf(RTABMAP_VERSION);
        return 0;
      }
    EOS
    args = std_cmake_args
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?
    system "cmake", ".", *args, "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DRTABMap_DIR=#{rtabmap_dir}"
    system "make"
    assert_equal version.to_s, shell_output(".test").strip
  end
end