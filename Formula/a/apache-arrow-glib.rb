class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-23.0.0/apache-arrow-23.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-23.0.0/apache-arrow-23.0.0.tar.gz"
  sha256 "12f6844a0ba3b99645cd2bc6cc4f44f6a174ab90da37e474f08b7d073433cb60"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c33ed94f637b158c62b3f66bc938f6fb22ff5ae22f7aa6b5292d577f17ffa80d"
    sha256 cellar: :any, arm64_sequoia: "dac719b679bf5f4eca7b9c36ebb5b3157ef70a6497d85632f4b4907ff3772054"
    sha256 cellar: :any, arm64_sonoma:  "780dd6424836b13e002562bdfcf7fab0a5e8923ee534eabffec3ca2601ec7e43"
    sha256 cellar: :any, sonoma:        "45791eff187ae2e9e04aa6fa03bd7159873b57c12a85d81440d06c32bf5aa87d"
    sha256               arm64_linux:   "c3c08e60c6bc6307ed48f422a35d47ec70b394842b0a8b869253083445269343"
    sha256               x86_64_linux:  "51b5f9656fd486b201f1b1cff197adcb1be189c77ee4dab2df23c07cdb2fbf50"
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
    (testpath/"test.c").write <<~C
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs arrow-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end