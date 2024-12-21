class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https:introlab.github.iortabmap"
  url "https:github.comintrolabrtabmaparchiverefstags0.21.4.tar.gz"
  sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"
  license "BSD-3-Clause"
  revision 8
  head "https:github.comintrolabrtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:  "3ab35d0f76835659984b70183d57a20588d9569187523261be461cc6e19cfe99"
    sha256                               arm64_ventura: "00f968f349ee73d0d29a0b72f85b54ee5436a6b80b94508bfdce8b77afdb0677"
    sha256                               sonoma:        "8d84b6e2b4575ad988f4d3126120fa3b5feab4e5a96d81fee3d242c1ca79f539"
    sha256                               ventura:       "6793f08bbcec9446a2320776517c09e2dfd121c5f295938bd423f9c7ee15b88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e122a1f417172e0e432ae9122748cb065262245a58fd83acb57f3ed756257ab5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"
  depends_on "qt"
  depends_on "sqlite"
  depends_on "vtk"

  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "glew"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "libpng"
    depends_on "lz4"
    depends_on "qhull"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test)
      find_package(RTABMap REQUIRED COMPONENTS core)
      add_executable(test test.cpp)
      target_link_libraries(test rtabmap::core)
    CMAKE
    (testpath"test.cpp").write <<~CPP
      #include <rtabmapcoreRtabmap.h>
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
    assert_equal version.to_s, shell_output(".buildtest").strip
  end
end