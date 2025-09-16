class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_9_1;sf=tgz"
  version "7.9.1"
  sha256 "e70b8c08c74f9693cbc91baa48610f1f5448ad167425fb8b957cf5a8f2cafed5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ff6334ea407940bc1be56e709668c12b4ea79ff60d37a84c74e83a7fe8c50951"
    sha256 cellar: :any,                 arm64_sequoia: "f9d87b8dde916c0a051b88b7766f8a0d69d5dd0383fc6dce29a08989f91268bf"
    sha256 cellar: :any,                 arm64_sonoma:  "778cd31a4361eb9ab61e88d5a34138fbc6d4925d6f4193dc0c8749480e903ffd"
    sha256 cellar: :any,                 arm64_ventura: "75ce5693d58108d89c9f033ce907429c046af9589c10298821e5179c54d6bec0"
    sha256 cellar: :any,                 sonoma:        "d1ddb8f31e96a5ef9de9bb4e8a29bbe2d8961b3ea5bf2a312a755f8642621e3b"
    sha256 cellar: :any,                 ventura:       "bc7eca82a63b2094211ade87f493062d5fb3e9dc84905504a73f66d713aafc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961d89f14088c689138fa3ba6b53ce5b7416576de3628e669dac533c971c5d2a"
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