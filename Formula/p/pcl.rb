class Pcl < Formula
  desc "Library for 2D3D image and point cloud processing"
  homepage "https:pointclouds.org"
  url "https:github.comPointCloudLibrarypclarchiverefstagspcl-1.13.1.tar.gz"
  sha256 "8ab98a9db371d822de0859084a375a74bdc7f31c96d674147710cf4101b79621"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comPointCloudLibrarypcl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edbace24153cdcd9382c0fd1fa856e1d21bdc5aa99d7b5a66a614b9968f2f010"
    sha256 cellar: :any,                 arm64_ventura:  "9f8570ed4ffe6693b7ac06e2f1702221798a3336556dcb3faaa82f2d82ddaddf"
    sha256 cellar: :any,                 arm64_monterey: "4fa617ebe0f8ee949887f4ae74ce1fd016da1c03a0642a263aeca504e7074644"
    sha256 cellar: :any,                 sonoma:         "196f36808b240b699a3cd6f73a9e605f61628a4b28af86ce98914df946c8f53d"
    sha256 cellar: :any,                 ventura:        "ea7675b1b52d6d41e16f9d8741df4b074f09542db3096ee4f17eab369d999e7d"
    sha256 cellar: :any,                 monterey:       "371b5d9112adfbd620bb32d235d27d93b616a72e66666ab45002f294b9c82f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb19d5724ccd53ff209a86dfc2c8aaca1332cd4de9216c567b304be8f97beedb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "cminpack"
  depends_on "eigen"
  depends_on "flann"
  depends_on "glew"
  depends_on "libpcap"
  depends_on "libusb"
  depends_on "qhull"
  depends_on "qt"
  depends_on "vtk"

  on_macos do
    depends_on "libomp"
  end

  # Fix build with Qt 6
  # https:github.comPointCloudLibrarypclissues5776
  patch :DATA

  def install
    args = std_cmake_args + %w[
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install Dir["#{bin}*.app"]
    end
  end

  test do
    assert_match "tiff files", shell_output("#{bin}pcl_tiff2pcd -h", 255)
    # inspired by https:pointclouds.orgdocumentationtutorialswriting_pcd.html
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
      project(pcd_write)
      find_package(PCL 1.2 REQUIRED)
      include_directories(${PCL_INCLUDE_DIRS})
      link_directories(${PCL_LIBRARY_DIRS})
      add_definitions(${PCL_DEFINITIONS})
      add_executable (pcd_write pcd_write.cpp)
      target_link_libraries (pcd_write ${PCL_LIBRARIES})
    EOS
    (testpath"pcd_write.cpp").write <<~EOS
      #include <iostream>
      #include <pcliopcd_io.h>
      #include <pclpoint_types.h>

      int main (int argc, char** argv)
      {
        pcl::PointCloud<pcl::PointXYZ> cloud;

         Fill in the cloud data
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
    EOS
    mkdir "build" do
      # the following line is needed to workaround a bug in test-bot
      # (Homebrewhomebrew-test-bot#544) when bumping the boost
      # revision without bumping this formula's revision as well
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["eigen"].opt_share"pkgconfig"
      ENV.delete "CPATH" # `error: no member named 'signbit' in the global namespace`
      args = std_cmake_args + ["-DQt5_DIR=#{Formula["qt@5"].opt_lib}cmakeQt5"]
      args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?
      system "cmake", "..", *args
      system "make"
      system ".pcd_write"
      assert_predicate (testpath"buildtest_pcd.pcd"), :exist?
      output = File.read("test_pcd.pcd")
      assert_match "POINTS 2", output
      assert_match "1 2 3", output
      assert_match "4 5 6", output
    end
  end
end
__END__
diff -pur aappscloud_composerincludepclappscloud_composersignal_multiplexer.h bappscloud_composerincludepclappscloud_composersignal_multiplexer.h
--- aappscloud_composerincludepclappscloud_composersignal_multiplexer.h	2023-05-10 08:44:47
+++ bappscloud_composerincludepclappscloud_composersignal_multiplexer.h	2023-07-31 18:04:25
@@ -42,6 +42,8 @@
 
 #pragma once
 
+#include <QList>
+#include <QObject>
 #include <QPointer>
 
 namespace pcl