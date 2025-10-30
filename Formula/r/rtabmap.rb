class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://ghfast.top/https://github.com/introlab/rtabmap/archive/refs/tags/0.22.1.tar.gz"
  sha256 "3988ad84c409e39048a6b23317076d4ee1a0123e94a5ad6574db93647d7a80c0"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "20a17805711d80ce4832d47579ed9364f7eab4efced20430b9f7ac71d0e86b6b"
    sha256                               arm64_sequoia: "13d8848d802e0ce6afc36dc7b55c7fd758d841fde7865dd740c402af42b36818"
    sha256                               arm64_sonoma:  "d8a8239c5d894d57f613789e70e27f9907dd05d0b2fe04d69407c714568cec78"
    sha256                               sonoma:        "f765722a4937ee9af13ce4f84bc6a0d5152059eb88a66062d2b89318ad2ef6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc9a8078f57e7cb5ab7a44a23a1ab03a0aaa93eaf6d575ebda6168795ebed23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db1652a2e0c0d1c6006fee21f2d2ea89e10a57996957c86838f3ade9cb09e95"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "sqlite"
  depends_on "vtk"

  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "freetype"
    depends_on "glew"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "libpng"
    depends_on "lz4"
    depends_on "qhull"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace reference to OpenCV's Cellar path
    opencv = Formula["opencv"]
    inreplace lib.glob("rtabmap-*/RTABMap_coreTargets.cmake"), opencv.prefix.realpath, opencv.opt_prefix

    return unless OS.mac?

    # Remove SDK include paths from CMake config files to avoid requiring specific SDK version
    sdk_include_regex = Regexp.escape("#{MacOS.sdk_for_formula(self).path}/usr/include")
    inreplace lib.glob("rtabmap-*/RTABMap_{core,utilite}Targets.cmake"), /;#{sdk_include_regex}([;"])/, "\\1"
  end

  test do
    # Check all references to SDK path were removed from CMake config files
    prefix.glob("**/*.cmake") { |cmake| refute_match %r{/MacOSX[\d.]*\.sdk/}, cmake.read } if OS.mac?

    output = if OS.linux?
      # Linux CI cannot start windowed applications due to Qt plugin failures
      shell_output("#{bin}/rtabmap-console --version")
    else
      shell_output("#{bin}/rtabmap --version")
    end
    assert_match "RTAB-Map:               #{version}", output

    # Required to avoid missing Xcode headers
    # https://github.com/Homebrew/homebrew-core/pull/162576/files#r1489824628
    ENV.delete "CPATH" if OS.mac? && MacOS::CLT.installed?

    rtabmap_dir = lib/"rtabmap-#{version.major_minor}"
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test)
      find_package(RTABMap REQUIRED COMPONENTS core)
      add_executable(test test.cpp)
      target_link_libraries(test rtabmap::core)
    CMAKE
    (testpath/"test.cpp").write <<~CPP
      #include <rtabmap/core/Rtabmap.h>
      #include <stdio.h>
      int main()
      {
        rtabmap::Rtabmap rtabmap;
        printf(RTABMAP_VERSION);
        return 0;
      }
    CPP

    args = std_cmake_args
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DRTABMap_DIR=#{rtabmap_dir}"
    system "cmake", "--build", "build"
    assert_equal version.to_s, shell_output("./build/test").strip
  end
end