class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.22.tar.xz"
  sha256 "76f949d0e59fc83363409b5ec5e15c1046fb7dd6589d3c1b920cec1fd29f9ff3"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1b8203d7c931f9064faa83022df410109f4352934b318d6fddbfc2e3edb85d88"
    sha256 cellar: :any, arm64_ventura:  "017ff7d5d960ebbbe6a03982ba057cb84f94e2df60f31bec4b1d2c2e892bd226"
    sha256 cellar: :any, arm64_monterey: "d17c452cb9a592873023398769e6fa754d7772b0e2ddbcb0191831758b66d879"
    sha256 cellar: :any, sonoma:         "1c59a079d05bc0f30e3b0d8de0d2904adb01dbe768a53ece38942e7150753518"
    sha256 cellar: :any, ventura:        "e0ac89371ce3fe639a9bfc3e82fe5f1f3e1025ceddfc887f2e514c5b73f6811b"
    sha256 cellar: :any, monterey:       "3b04d0b3ab3e16c5b3e66a0e97f42c6a5f875c8fb1831cf5dc46fd145eb2958a"
    sha256               x86_64_linux:   "2e87acde2db22b7eb83ecbeef00fdc571750a1df9b2e5ae1d98c752a82bbdb0f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "zix"

  def python3
    "python3.12"
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
    (testpath/"test.c").write <<~EOS
      #include <lilv/lilv.h>

      int main(void) {
        LilvWorld* const world = lilv_world_new();
        lilv_world_free(world);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/lilv-0", "-L#{lib}", "-llilv-0", "-o", "test"
    system "./test"

    system python3, "-c", "import lilv"
  end
end