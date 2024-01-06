class Pcl < Formula
  desc "Library for 2D3D image and point cloud processing"
  homepage "https:pointclouds.org"
  url "https:github.comPointCloudLibrarypclarchiverefstagspcl-1.14.0.tar.gz"
  sha256 "de297b929eafcb93747f12f98a196efddf3d55e4edf1b6729018b436d5be594d"
  license "BSD-3-Clause"
  head "https:github.comPointCloudLibrarypcl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a37ecee5931532417ef687506ee58522e65f8f9f23287d47f4a238bccce42042"
    sha256 cellar: :any,                 arm64_ventura:  "d1fb316f242b4989f2a65fe94f42c23145e1b3552c6e0f4eda64559998128cbd"
    sha256 cellar: :any,                 arm64_monterey: "b6c07560e333078ebe7a62e5faef3b1b96c3c6154d042639f79e99eaba381c46"
    sha256 cellar: :any,                 sonoma:         "ee0ef1da384e282bc770af19f56ecb0684c5a52c5edf2725d9fe21e9699dada2"
    sha256 cellar: :any,                 ventura:        "66c8fdebff5c21b9b7d1752c267867ed0bd65b4639a7256f66f0c499b00f35ca"
    sha256 cellar: :any,                 monterey:       "5a13fd68e4d002c4229ae28269f44e534b39d24ffbac347d87a17cec40c04f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb0e5b6753eacc087eed1739de76c41dd6c44bfb01b31556b6d61071d56db5b"
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