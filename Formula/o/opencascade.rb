class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_9_2;sf=tgz"
  version "7.9.2"
  sha256 "e9f69bde521e718f10f1896e5bea070fbd5dfb205d8da422f5be2d521db666c5"
  license "LGPL-2.1-only"

  # The first-party download page (https://dev.opencascade.org/release)
  # references version 7.5.0 and hasn't been updated for later maintenance
  # releases (e.g., 7.6.2, 7.5.2), so we check the Git tags instead. Release
  # information is posted at https://dev.opencascade.org/forums/occt-releases
  # but the text varies enough that we can't reliably match versions from it.
  livecheck do
    url "https://git.dev.opencascade.org/repos/occt.git"
    regex(/^v?(\d+(?:[._]\d+)+(?:p\d+)?)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4660451ad938efaa9866c11e26feaf6477e9ffc2ed465ec0e9c9ee3e883aa1c7"
    sha256 cellar: :any,                 arm64_sequoia: "909aa33f35f20ba42068fcc35030389f878f6fa71dafa481148bcc40a1224922"
    sha256 cellar: :any,                 arm64_sonoma:  "192f5b9934455b54a1e4d90b7bfa4b0f983aea39ceae5f75ff49e09d519ccb01"
    sha256 cellar: :any,                 sonoma:        "94081fbc6d9504ef3fd83ca3d76cdd86ca3808d009b68c6e33a6920bb724c314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3878643a038002cd189e57aff2dd2424159cc46b8126ae16b08c2d40df707926"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "rapidjson" => :build
  depends_on "fontconfig"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "tbb"
  depends_on "tcl-tk@8" # TCL 9 issue: https://tracker.dev.opencascade.org/view.php?id=33725

  on_linux do
    depends_on "libx11"
    depends_on "mesa" # For OpenGL
  end

  def install
    # Fix incorrect version
    inreplace "adm/cmake/version.cmake", "set (OCC_VERSION_MAINTENANCE 1 )", "set (OCC_VERSION_MAINTENANCE 2 )"

    tcltk = Formula["tcl-tk@8"]
    libtcl = tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")
    libtk = tcltk.opt_lib/shared_library("libtk#{tcltk.version.major_minor}")

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_FREEIMAGE=ON",
                    "-DUSE_RAPIDJSON=ON",
                    "-DUSE_TBB=ON",
                    "-DINSTALL_DOC_Overview=ON",
                    "-DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF",
                    "-D3RDPARTY_FREEIMAGE_DIR=#{Formula["freeimage"].opt_prefix}",
                    "-D3RDPARTY_FREETYPE_DIR=#{Formula["freetype"].opt_prefix}",
                    "-D3RDPARTY_RAPIDJSON_DIR=#{Formula["rapidjson"].opt_prefix}",
                    "-D3RDPARTY_RAPIDJSON_INCLUDE_DIR=#{Formula["rapidjson"].opt_include}",
                    "-D3RDPARTY_TBB_DIR=#{Formula["tbb"].opt_prefix}",
                    "-D3RDPARTY_TCL_DIR:PATH=#{tcltk.opt_prefix}",
                    "-D3RDPARTY_TK_DIR:PATH=#{tcltk.opt_prefix}",
                    "-D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{tcltk.opt_include}/tcl-tk",
                    "-D3RDPARTY_TK_INCLUDE_DIR:PATH=#{tcltk.opt_include}/tcl-tk",
                    "-D3RDPARTY_TCL_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TK_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TCL_LIBRARY:FILEPATH=#{libtcl}",
                    "-D3RDPARTY_TK_LIBRARY:FILEPATH=#{libtk}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The soname / install name of libtbb and libtbbmalloc are versioned only
    # by the minor version (e.g., `libtbb.so.12`), but Open CASCADE's CMake
    # config files reference the fully-versioned filenames (e.g.,
    # `libtbb.so.12.11`).
    # This mandates rebuilding opencascade upon tbb's minor version updates.
    # To avoid this, we change the fully-versioned references to the minor-only
    # version. For example:
    #   libtbb.so.12.11 => libtbb.so.12
    #   libtbbmalloc.so.2.11 => libtbbmalloc.so.2
    #   libtbb.12.11.dylib => libtbb.12.dylib
    #   libtbbmalloc.2.11.dylib => libtbbmalloc.2.dylib
    # See also:
    #   https://github.com/Homebrew/homebrew-core/issues/129111
    #   https://dev.opencascade.org/content/cmake-files-macos-link-non-existent-libtbb128dylib
    tbb_regex = /
      libtbb
      (malloc)? # 1
      (\.so)? # 2
      \.(\d+) # 3
      \.(\d+) # 4
      (\.dylib)? # 5
    /x
    inreplace (lib/"cmake/opencascade").glob("*.cmake") do |s|
      s.gsub! tbb_regex, 'libtbb\1\2.\3\5', audit_result: false
    end

    bin.env_script_all_files(libexec, CASROOT: prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -b -c \"pload ALL\"")

    # Discard the first line ("DRAW is running in batch mode"), and check that the second line is "1"
    assert_equal "1", output.split("\n", 2)[1].chomp

    # Make sure hardcoded library name references in our CMake config files are valid.
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      set(CMAKE_CXX_STANDARD 11)
      project(test LANGUAGES CXX)
      find_package(OpenCASCADE REQUIRED)
      add_executable(test main.cpp)
      target_include_directories(test SYSTEM PRIVATE "${OpenCASCADE_INCLUDE_DIR}")
      target_link_libraries(test PRIVATE TKernel)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <Quantity_Color.hxx>
      #include <Standard_Version.hxx>
      #include <iostream>
      int main() {
        Quantity_Color c;
        std::cout << "OCCT Version: " << OCC_VERSION_COMPLETE << std::endl;
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    ENV.append_path "LD_LIBRARY_PATH", lib if OS.linux?
    assert_equal "OCCT Version: #{version}", shell_output("./build/test").chomp
  end
end