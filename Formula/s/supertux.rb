class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  license "GPL-3.0-or-later"
  revision 13

  stable do
    url "https://ghfast.top/https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
    sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"

    depends_on "boost"

    # Backport fix for newer GCC
    patch do
      url "https://github.com/SuperTux/supertux/commit/81809dd5e6f611b1d64d952f6d96310bcc9c5fca.patch?full_index=1"
      sha256 "cd251ef6831c482c32e5aa2c56422cad2898747493797b4018f02131ea19dc88"
    end

    # Workaround to build with Boost 1.89.0 until new release that drops Boost dependency
    # https://github.com/SuperTux/supertux/commit/5333cebf629eb20621b284fc96b494257f3314bb
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f132591d005cf115d8a46b7474a06888280a77ae5602a8e496fad8f9a13ff188"
    sha256 cellar: :any,                 arm64_sequoia: "7f561ffc7bb5bfd61a6696e3777a43af3d5ae0fd8faccb1410a48d29834b7d92"
    sha256 cellar: :any,                 arm64_sonoma:  "d24c312dc243c36992f03122beda7ef9624fc78854d6c0a86a587fae8280009e"
    sha256 cellar: :any,                 sonoma:        "00c834e53792059bf1288836b729386935644adc2a826d0ee0efa48414341e96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f710ee2be2cf307918e3b1e7f294c6e2ab05ce755ad3e1b554dfbd0ba1ab34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d04ac1cb2ab4046c28cc9da72577dd540cdf17bdbbf82cd2f954c57abdfc34"
  end

  head do
    url "https://github.com/SuperTux/supertux.git", branch: "master"

    depends_on "fmt"
    depends_on "openal-soft"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "openal-soft"
  end

  def install
    # Support cmake 4 build, upstream pr ref, https://github.com/SuperTux/supertux/pull/3290
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    args = [
      "-DINSTALL_SUBDIR_BIN=bin",
      "-DINSTALL_SUBDIR_SHARE=share/supertux",
      # Without the following option, Cmake intend to use the library of MONO framework.
      "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}" if build.head?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary files
    rm_r(share/"applications")
    rm_r(share/"pixmaps")
    rm_r(prefix/"MacOS") if OS.mac?
  end

  test do
    (testpath/"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index b77029c0a..1842b4943 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -171,7 +171,7 @@ if(ENABLE_BOOST_STATIC_LIBS)
 else(ENABLE_BOOST_STATIC_LIBS)
   set(Boost_USE_STATIC_LIBS FALSE)
 endif(ENABLE_BOOST_STATIC_LIBS)
-find_package(Boost REQUIRED COMPONENTS filesystem system date_time locale)
+find_package(Boost REQUIRED COMPONENTS filesystem date_time locale)
 include_directories(SYSTEM ${Boost_INCLUDE_DIR})
 link_directories(${Boost_LIBRARY_DIRS})