class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://downloads.xiph.org/releases/opus/opusfile-0.12.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/opus/opusfile-0.12.tar.gz"
  sha256 "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://www.opus-codec.org/downloads/"
    regex(/href=.*?opusfile[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2d8a06a9cf6bae410e9112ec383e928b69986c8f6d1b91cde5961008e1ec077"
    sha256 cellar: :any,                 arm64_monterey: "cd2de61cdf56792c4d6e03d5af1c1319b028d7c0227bbeb8b221f85c6928c301"
    sha256 cellar: :any,                 arm64_big_sur:  "c82b83a7d1a4847695a7667de5537fa2b75fc737d0caedf3562891019b7e8c37"
    sha256 cellar: :any,                 ventura:        "3f71655f0ae4529bbe68cdf389f44b835130e77078758674f0f433327aa7341f"
    sha256 cellar: :any,                 monterey:       "fa8d9e078297d10e650883b4c259d46bf955031174af802849e4151ef3b5dccc"
    sha256 cellar: :any,                 big_sur:        "f97ed204769d1f151372469bc4364076add0c7e15035bdba1a9aa630c2ee2063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b0a03f7494d92eb31cdc658c7aca5d971a1c9482ad899a2fe6643715d887f4"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opusfile.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "openssl@3"
  depends_on "opus"

  resource "sample" do
    url "https://dl.espressif.com/dl/audio/gs-16b-1c-44100hz.opus"
    sha256 "f80fabebe4e00611b93019587be9abb36dbc1935cb0c9f4dfdf5c3b517207e1b"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("sample").stage { testpath.install Pathname.pwd.children(false).first => "sample.opus" }
    (testpath/"test.c").write <<~EOS
      #include <opus/opusfile.h>
      #include <stdlib.h>
      int main(int argc, const char **argv) {
        int ret;
        OggOpusFile *of;

        of = op_open_file(argv[1], &ret);
        if (of == NULL) {
          fprintf(stderr, "Failed to open file '%s': %i\\n", argv[1], ret);
          return EXIT_FAILURE;
        }
        op_free(of);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["opus"].include}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    system "./test", "sample.opus"
  end
end