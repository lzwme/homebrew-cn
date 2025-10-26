class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.26.tar.xz"
  sha256 "22feed30bc0f952384a25c2f6f4b04e6d43836408798ed65a8a934c055d5d8ac"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "90ae823eb2f694a459acd9a82add438afeae7372bb5027fb96f7284535f38765"
    sha256 cellar: :any, arm64_sequoia: "f67b63d7cdd471472d24b017eedf01c548f17b07c76ddfbe3ed75bf36099f90b"
    sha256 cellar: :any, arm64_sonoma:  "6374dd43e1c57accd80314b283f9b79e8a37a7b633a949c95bbc49f94704e12d"
    sha256 cellar: :any, sonoma:        "717aa04eb3a99b7bf3f911b4c0a82da954c8c6c200c24f6a011ec74f0d562f9e"
    sha256               arm64_linux:   "5e940b3cdae1f87b18606b0337e5506f4fbe6812b248778f81e35df51c9fc063"
    sha256               x86_64_linux:  "ec14d34d2171150d32a7a49a17ad6ff6acdbda7b9020d06a7077ce3542a16486"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "zix"

  def python3
    "python3.14"
  end

  def install
    # FIXME: Meson tries to install into `prefix/HOMEBREW_PREFIX/lib/pythonX.Y/site-packages`
    #        without setting `python.*libdir`.
    prefix_site_packages = prefix/Language::Python.site_packages(python3)
    system "meson", "setup", "build", "-Dtests=disabled",
                                      "-Dbindings_py=enabled",
                                      "-Dtools=enabled",
                                      "-Dpython.platlibdir=#{prefix_site_packages}",
                                      "-Dpython.purelibdir=#{prefix_site_packages}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lilv/lilv.h>

      int main(void) {
        LilvWorld* const world = lilv_world_new();
        lilv_world_free(world);
      }
    C
    system ENV.cc, "test.c", "-I#{include}/lilv-0", "-L#{lib}", "-llilv-0", "-o", "test"
    system "./test"

    system python3, "-c", "import lilv"
  end
end