class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  url "https://ghfast.top/https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.15.1.tar.gz"
  sha256 "e1d862c7b6bd27a45884a825a2e509bfcbd4561307d5bfe17ce5c8a3d94a6c29"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c06cc9485a67cba638ab78dbd215b4c8839f420e26fffed015bd0f95c7c07a70"
    sha256 cellar: :any,                 arm64_sequoia: "982b8332e9e6de238fbf34c31057dc15767166f63f7b2b9c3f57f55d682e9b01"
    sha256 cellar: :any,                 arm64_sonoma:  "122837c0587bd4e41ec76a36c5840d657e64e0d8465b53fa87f64637fbd66c1f"
    sha256 cellar: :any,                 sonoma:        "d65d4d87b0f7e60a4be06db963bdaff7dca9c2bfaf837a2a79998838c8e6fc10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d545ba9d0477fb775588af1f44165524b90236acee0f715e8e3513fd1b42a7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0870d2eb742f352c2ca71955d0cd4711345bfec5beac6b8e903540a775d2cd64"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "cjson"
  depends_on "eigen"
  depends_on "flann"
  depends_on "glew"
  depends_on "libpcap"
  depends_on "libpng"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "qhull"
  depends_on "qtbase"
  depends_on "vtk"

  on_macos do
    depends_on "freetype"
    depends_on "libomp"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Apply open PR to fix build with Boost 1.89
  # PR ref: https://github.com/PointCloudLibrary/pcl/pull/6330
  patch do
    url "https://github.com/PointCloudLibrary/pcl/commit/8dfb0e10ebdf4a5086328b38f854294d2d6b1627.patch?full_index=1"
    sha256 "f31c11abb6bec8864b7a109472768ba80e87ddf90533890c303294d264f389e1"
  end

  def install
    args = %w[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_apps=AUTO_OFF
      -DBUILD_apps_3d_rec_framework=AUTO_OFF
      -DBUILD_apps_cloud_composer=AUTO_OFF
      -DBUILD_apps_in_hand_scanner=AUTO_OFF
      -DBUILD_apps_point_cloud_editor=AUTO_OFF
      -DBUILD_examples:BOOL=OFF
      -DBUILD_global_tests:BOOL=OFF
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=AUTO_OFF
      -DBUILD_simulation:BOOL=ON
      -DWITH_CUDA:BOOL=OFF
      -DWITH_DOCS:BOOL=OFF
      -DWITH_TUTORIALS:BOOL=OFF
      -DBoost_USE_DEBUG_RUNTIME:BOOL=OFF
    ]

    args << if build.head?
      "-DBUILD_apps_modeler=AUTO_OFF"
    else
      "-DBUILD_apps_modeler:BOOL=OFF"
    end

    # The AppleClang versions shipped on current MacOS versions do not support the -march=native flag on arm
    args << "-DPCL_ENABLE_MARCHNATIVE:BOOL=OFF" if build.bottle?

    # Work around ../../lib/libpcl_cc_tool_interface.a(mocs_compilation.cpp.o):
    # relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `...' which may bind
    # externally can not be used when making a shared object; recompile with -fPIC
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install bin.glob("*.app")
  end

  test do
    assert_match "tiff files", shell_output("#{bin}/pcl_tiff2pcd -h", 255)
    # inspired by https://pointclouds.org/documentation/tutorials/writing_pcd.html
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
      project(pcd_write)
      find_package(PCL 1.2 REQUIRED)
      include_directories(${PCL_INCLUDE_DIRS})
      link_directories(${PCL_LIBRARY_DIRS})
      add_definitions(${PCL_DEFINITIONS})
      add_executable (pcd_write pcd_write.cpp)
      target_link_libraries (pcd_write ${PCL_LIBRARIES})
    CMAKE
    (testpath/"pcd_write.cpp").write <<~CPP
      #include <iostream>
      #include <pcl/io/pcd_io.h>
      #include <pcl/point_types.h>

      int main (int argc, char** argv)
      {
        pcl::PointCloud<pcl::PointXYZ> cloud;

        // Fill in the cloud data
        cloud.width    = 2;
        cloud.height   = 1;
        cloud.is_dense = false;
        cloud.points.resize (cloud.width * cloud.height);
        int i = 1;
        for (auto& point: cloud)
        {
          point.x = i++;
          point.y = i++;
          point.z = i++;
        }

        pcl::io::savePCDFileASCII ("test_pcd.pcd", cloud);
        return (0);
      }
    CPP
    # the following line is needed to workaround a bug in test-bot
    # (Homebrew/homebrew-test-bot#544) when bumping the boost
    # revision without bumping this formula's revision as well
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["eigen"].opt_share/"pkgconfig"

    ENV.delete "CPATH" # `error: no member named 'signbit' in the global namespace`

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/pcd_write"
    assert_path_exists testpath/"test_pcd.pcd"
    output = File.read("test_pcd.pcd")
    assert_match "POINTS 2", output
    assert_match "1 2 3", output
    assert_match "4 5 6", output
  end
end