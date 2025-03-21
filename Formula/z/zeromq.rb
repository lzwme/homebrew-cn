class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https:zeromq.org"
  url "https:github.comzeromqlibzmqreleasesdownloadv4.3.5zeromq-4.3.5.tar.gz"
  sha256 "6653ef5910f17954861fe72332e68b03ca6e4d9c7160eb3a8de5a5a913bfab43"
  license "MPL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8898ce6776591ad282627fd7215f02ade8f5c5ec3d4dd457ce25aba12c3c1c18"
    sha256 cellar: :any,                 arm64_sonoma:   "3bf8942ece99f0457125006cf729f24823e09a3f6bd2257e8be9873e5783a0a1"
    sha256 cellar: :any,                 arm64_ventura:  "0f670cd22b752c640a01f1f3353f8cdf7a6bf31beefad511c17baf315ad848f4"
    sha256 cellar: :any,                 arm64_monterey: "3a8bc264cb466f765f65f73b0db3c202899656efa11b2df37bd961a224589e20"
    sha256 cellar: :any,                 sonoma:         "986910eab9519ca92f167b545cde5992124a963b56d1346f2f917368e9a7eb43"
    sha256 cellar: :any,                 ventura:        "25344444cf8c0583f65b1f36fdf11edc40ce2fe637fa04e34fe28c730573dadc"
    sha256 cellar: :any,                 monterey:       "c8c1cafdffdc020cf504bc59888d61a016df6cdfc12650d89a43a846edb77ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1bec0b28dfb3b515f6095d00e4fdb0b4ec458e02b4fbecac8a53a0c18cf7ea01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904b3146ea9aab3b4fdb584c74be1fa762145d3435eef653becc38ce0600c1bc"
  end

  head do
    url "https:github.comzeromqlibzmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "xmlto" => :build

  depends_on "libsodium"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    if OS.mac? && MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"

    # Disable libunwind support due to pkg-config problem
    # https:github.comHomebrewhomebrew-corepull35940#issuecomment-454177261

    system ".autogen.sh" if build.head?
    system ".configure", "--with-libsodium", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system ".test"
    system "pkg-config", "libzmq", "--cflags"
    system "pkg-config", "libzmq", "--libs"
  end
end