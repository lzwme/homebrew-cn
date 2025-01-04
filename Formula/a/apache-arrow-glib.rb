class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-18.1.0apache-arrow-18.1.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-18.1.0apache-arrow-18.1.0.tar.gz"
  sha256 "2dc8da5f8796afe213ecc5e5aba85bb82d91520eff3cf315784a52d0fa61d7fc"
  license "Apache-2.0"
  head "https:github.comapachearrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8ecf1131a110a5dc2360eaf200e7963c733e2d795a66ee064b00e89cebed1120"
    sha256 cellar: :any, arm64_sonoma:  "0b1bf55b09a97b572ecfb061c0a8a0ee1cc47b5a81cd061aea4df1444996ec52"
    sha256 cellar: :any, arm64_ventura: "53813084c6f1d433319ebc6561625d29fd1d92a30b61c65627a13dc5ddc38082"
    sha256 cellar: :any, sonoma:        "776f95adbac847e9f64569e76b2e8fc211beb2922384f2c05c08b8ed1813f05a"
    sha256 cellar: :any, ventura:       "a6e2f525044b772309ff99965a6144ddef523c492a986db71df4f8aed453cbdb"
    sha256               x86_64_linux:  "2dc901ef5820553b25be2cc94cc4f397601313adbc54e78f916143e44b32f64f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    system "meson", "setup", "build", "c_glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <arrow-glibarrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs arrow-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end