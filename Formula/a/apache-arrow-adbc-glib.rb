class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-24/apache-arrow-adbc-24.tar.gz"
  sha256 "2b4b420937f62f7ae56f46dbd6951a5e4ef0da43158080a58cb44cdd09a8b2e0"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fcd07ab6362e46cc47898327ead6f3e344d20492d15b2a09b9350686ea5155bc"
    sha256 cellar: :any, arm64_sequoia: "990179bc322c82ee1ee47da69b20b34dd4214f0be9a3a2933b628f73a21912b9"
    sha256 cellar: :any, arm64_sonoma:  "f75e240ca3a3b1ab32c4fff81c8a43c216cc2cd6b6d292173cde00b9ed5c10e0"
    sha256 cellar: :any, sonoma:        "2e4e699391bed8daf19940ee02c76b5d9c55830b7b128804975ab518d3ec11b1"
    sha256               arm64_linux:   "79888f76bd522ff17213e35676cfffe69dc69657220affa951257f654847c2b2"
    sha256               x86_64_linux:  "eba5d1f7de037b1018d6b77ae6a479f6d675503d2a17639dde36a7484b2177c7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow-adbc"
  depends_on "apache-arrow-glib"
  depends_on "glib"

  def install
    system "meson", "setup", "build", "glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <adbc-glib/adbc-glib.h>
      int main(void) {
        GError *error = NULL;
        GADBCDatabase *database = gadbc_database_new(&error);
        if (database) {
          g_object_unref(database);
        }
        return error ? 1 : 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs adbc-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end