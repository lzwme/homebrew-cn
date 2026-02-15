class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.3.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3.1/zlib-1.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.3.1.tar.gz"
  sha256 "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
  license "Zlib"
  revision 1
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d02341630db7995cc3fbab2fbc4c972a5f3234e06e2ea7d66befe77b648af7a4"
    sha256 cellar: :any,                 arm64_sequoia: "a9c3e660b585126eeb798217e9974f8657224cc48c4e7ea7bc76fae95ab04a14"
    sha256 cellar: :any,                 arm64_sonoma:  "93836f9d2dd4d0e28f09d616fb64e6890d3fdf8644d6134915134da0dca283f2"
    sha256 cellar: :any,                 sonoma:        "d8486be76c60648958734b10999fefa078e094738734e20594d3c654f44bf5be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3c57e35dd35f2ae6443cd03dbf5962a6f347c8943b39091410a66f1d2f6c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dc996403a69700b568d92d9283a02b530e9349e5771019f226ee35505d26bd9"
  end

  keg_only :provided_by_macos

  on_linux do
    keg_only "it conflicts with zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "zpipe.c" do
      url "https://ghfast.top/https://raw.githubusercontent.com/madler/zlib/3f5d21e8f573a549ffc200e17dd95321db454aa1/examples/zpipe.c"
      mirror "http://zlib.net/zpipe.c"
      sha256 "e79717cefd20043fb78d730fd3b9d9cdf8f4642307fc001879dc82ddb468509f"
    end

    testpath.install resource("zpipe.c")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end