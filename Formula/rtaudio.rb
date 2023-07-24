class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-6.0.0.tar.gz"
  sha256 "b4a2531bdcfe3368c78182a151885cc61cb1fc49fcdeaac520c55bd230ea5bfa"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtaudio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "96e8e23767a6ce3216bffdde04055a7fb8aae08abe6be933f4ab8accea6994e5"
    sha256 cellar: :any,                 arm64_monterey: "3eb3baba3092c0b0cd9c4b4e0bf929bef0e4ab24c0bedd44e8e08bdb0f7a69ad"
    sha256 cellar: :any,                 arm64_big_sur:  "f2a0e46948b488ca1d3c948c3015574b622be8bbf30fb29d120eaf78ea25925b"
    sha256 cellar: :any,                 ventura:        "a3ef1c423dab691ab424f182c6c49d303bc34c667720ead5032d45ed35f06232"
    sha256 cellar: :any,                 monterey:       "2cab984562823fc65a20c77cba8df66f99d51e9a8a8b22fef4eb1bb9e0b5ebf0"
    sha256 cellar: :any,                 big_sur:        "5b44577c3c58a1bed8a6de5199f302ff3c52c0e49a7f5964dee719e963e3f9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee1b3af4b8b386f2f0c31ca8b07fdb7c03ed55834c646def3ddd200387b740f"
  end

  head do
    url "https://github.com/thestk/rtaudio.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images] if build.stable?
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tests/testall.cpp", "-o", "test", "-std=c++11",
           "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio"
    system "./test"
  end
end