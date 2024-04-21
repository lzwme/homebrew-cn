class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https:introlab.github.iortabmap"
  url "https:github.comintrolabrtabmaparchiverefstags0.21.4.tar.gz"
  sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comintrolabrtabmap.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "204479c6db2eef6b7567e153c3f966a326abeb5c059f4bfa2c79af3faf155611"
    sha256                               arm64_ventura:  "1c9b33f634cce573b7d5ac8179bc5c62b57d76d6b573c5bd6a7cf66b96e69d1f"
    sha256                               arm64_monterey: "177c8f36ccaffea42be206c6721d460998604322344307890d86032bcf249173"
    sha256                               sonoma:         "ceb86498af8998e3cc77505128ed316f5dc0ab5c05d4eca6e4bfd3ac52ab9fdb"
    sha256                               ventura:        "225a66065f4b20d9df08c143adc04fd4d46d9ed9c2f804e77b2d3be451d9734b"
    sha256                               monterey:       "b3f6c0c01deb299c3b7e38bc2d3023e6cdd646c591ec2f57ade181c94040f60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113a8b8dfa2e7ddc0fe9df44fc2f91e3328e2b00ccd5136e369c48b6452ba866"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"

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