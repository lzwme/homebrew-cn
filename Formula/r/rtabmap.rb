class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https:introlab.github.iortabmap"
  url "https:github.comintrolabrtabmaparchiverefstags0.21.4.tar.gz"
  sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"
  license "BSD-3-Clause"
  revision 5
  head "https:github.comintrolabrtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "66472e8c3097335ee0bd8636ac80a31e6bb7cd104e0baf009f80b6e8f9ec13a6"
    sha256                               arm64_ventura:  "693c3999f1b8372b6fb740bfe12b2995279307299d2d312f21f0ca63096089f6"
    sha256                               arm64_monterey: "d045352baa053e9fa267e5dc07348046ed0b535257535bbddec1cf000bb02800"
    sha256                               sonoma:         "2ea7d9f0acac166234ae94ed6e90b2156b6867165717281eaca82037fbe3a6d2"
    sha256                               ventura:        "d55b3d2d30cee78028c91a0be5b94bbd6e75020bc770ae6b3803a06e73999841"
    sha256                               monterey:       "30fec17d83d4f197fc6c82057978842273c2bbca4e8882995e3d03d2f0e196d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc391d3a84c02ce62dd54f7c4e8c1d93b911e5c73be85281ab73752766bb78d"
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

    system "cmake", "-S", ".", "-B", "build", *args, "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DRTABMap_DIR=#{rtabmap_dir}"
    system "cmake", "--build", "build"
    assert_equal version.to_s, shell_output(".buildtest").strip
  end
end