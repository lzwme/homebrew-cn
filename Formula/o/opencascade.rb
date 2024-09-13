class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CADCAMCAE"
  homepage "https:dev.opencascade.org"
  url "https:git.dev.opencascade.orggitweb?p=occt.git;a=snapshot;h=refstagsV7_8_1;sf=tgz"
  version "7.8.1"
  sha256 "33f2bdb67e3f6ae469f3fa816cfba34529a23a9cb736bf98a32b203d8531c523"
  license "LGPL-2.1-only"

  # The first-party download page (https:dev.opencascade.orgrelease)
  # references version 7.5.0 and hasn't been updated for later maintenance
  # releases (e.g., 7.6.2, 7.5.2), so we check the Git tags instead. Release
  # information is posted at https:dev.opencascade.orgforumsocct-releases
  # but the text varies enough that we can't reliably match versions from it.
  livecheck do
    url "https:git.dev.opencascade.orgreposocct.git"
    regex(^v?(\d+(?:[._]\d+)+(?:p\d+)?)$i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "16410eed828af2c6c730eacf374043f61689b92fcf3b996d7e58f70fa12c3d0f"
    sha256 cellar: :any,                 arm64_sonoma:   "725b60ffcfcdc50edb28dd8c5d8d87c44fd9e2c5267c64c677b6098e64b68f83"
    sha256 cellar: :any,                 arm64_ventura:  "ebd45601d545eeeb65ac441d57a1a90b0cc615707eb9b0896d6161e9ace3ee2d"
    sha256 cellar: :any,                 arm64_monterey: "55758e47849fa92c48982fb5c0898d4c53a034d4de6cbb64f69a555f36de2a8c"
    sha256 cellar: :any,                 sonoma:         "f89cadd051255fe193fe39aebd04c2c2716393568189c343501767b4950d3a4a"
    sha256 cellar: :any,                 ventura:        "f6b02e2c9146c3834f40673233f6091d50464f777416b80338d1a0e705096cbf"
    sha256 cellar: :any,                 monterey:       "49121a638da14d08516ccefc1b28f0d7591984cc913fae410cc9f18362b68908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f813cfab8bc0c4dcf3ec91c7d6ca16c2e1ad732bda317f6d12a9334095850b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "rapidjson" => :build
  depends_on "fontconfig"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "tbb"
  depends_on "tcl-tk"

  on_linux do
    depends_on "libx11"
    depends_on "mesa" # For OpenGL
  end

  # Backport fix for incorrect type
  patch do
    url "https:github.comOpen-Cascade-SASOCCTcommit7236e83dcc1e7284e66dc61e612154617ef715d6.patch?full_index=1"
    sha256 "ed8848b3891df4894de56ae8f8c51f6a4b78477c0063d957321c1cace4613c29"
  end

  def install
    tcltk = Formula["tcl-tk"]
    libtcl = tcltk.opt_libshared_library("libtcl#{tcltk.version.major_minor}")
    libtk = tcltk.opt_libshared_library("libtk#{tcltk.version.major_minor}")

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
                    "-D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{tcltk.opt_include}tcl-tk",
                    "-D3RDPARTY_TK_INCLUDE_DIR:PATH=#{tcltk.opt_include}tcl-tk",
                    "-D3RDPARTY_TCL_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TK_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TCL_LIBRARY:FILEPATH=#{libtcl}",
                    "-D3RDPARTY_TK_LIBRARY:FILEPATH=#{libtk}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The soname  install name of libtbb and libtbbmalloc are versioned only
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
    #   https:github.comHomebrewhomebrew-coreissues129111
    #   https:dev.opencascade.orgcontentcmake-files-macos-link-non-existent-libtbb128dylib
    tbb_regex = 
      libtbb
      (malloc)? # 1
      (\.so)? # 2
      \.(\d+) # 3
      \.(\d+) # 4
      (\.dylib)? # 5
    x
    inreplace (lib"cmakeopencascade").glob("*.cmake") do |s|
      s.gsub! tbb_regex, 'libtbb\1\2.\3\5', audit_result: false
    end

    bin.env_script_all_files(libexec, CASROOT: prefix)

    # Some apps expect resources in legacy ${CASROOT}src directory
    prefix.install_symlink pkgshare"resources" => "src"
  end

  test do
    output = shell_output("#{bin}DRAWEXE -b -c \"pload ALL\"")

    # Discard the first line ("DRAW is running in batch mode"), and check that the second line is "1"
    assert_equal "1", output.split("\n", 2)[1].chomp

    # Make sure hardcoded library name references in our CMake config files are valid.
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      set(CMAKE_CXX_STANDARD 11)
      project(test LANGUAGES CXX)
      find_package(OpenCASCADE REQUIRED)
      add_executable(test main.cpp)
      target_include_directories(test SYSTEM PRIVATE "${OpenCASCADE_INCLUDE_DIR}")
      target_link_libraries(test PRIVATE TKernel)
    CMAKE

    (testpath"main.cpp").write <<~CPP
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
    assert_equal "OCCT Version: #{version}", shell_output(".buildtest").chomp
  end
end