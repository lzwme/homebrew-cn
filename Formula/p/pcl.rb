class Pcl < Formula
  desc "Library for 2D3D image and point cloud processing"
  homepage "https:pointclouds.org"
  url "https:github.comPointCloudLibrarypclarchiverefstagspcl-1.14.0.tar.gz"
  sha256 "de297b929eafcb93747f12f98a196efddf3d55e4edf1b6729018b436d5be594d"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comPointCloudLibrarypcl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d6a2445628d80caef165a1725ec4fe482c56a842507dc38dace4f42f5643c20"
    sha256 cellar: :any,                 arm64_ventura:  "5ea57ad75157527441b0c268f5e86df0292cb9efc26ea679ba4eb39750a85742"
    sha256 cellar: :any,                 arm64_monterey: "9ef5c624f47b90e0f630269363dfa6393844214d0ca9b4bf7da2a285a2092be4"
    sha256 cellar: :any,                 sonoma:         "3d670c49251a6a98cc1395113b999ca0c329d01f143b6a44ff53ab19e9356f18"
    sha256 cellar: :any,                 ventura:        "f9e6cc80ebc3cbf47976e256d5b2814c4cb8d9e93604541d036a81af999be34a"
    sha256 cellar: :any,                 monterey:       "99a66f4f0a511272a762976c3c1de4192a3fea0cdf86ccac169bc5960628e30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ba89986eca360c9790e771996e2435e30b4ad39a6e19f29d9d949a5f652a0d"
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