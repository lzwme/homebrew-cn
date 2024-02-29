class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.12.1.tar.xz"
  sha256 "d7747f8ec1baa6ff5c096a9dd587c061233dec90da0f1aedd66d830f6db6996a"
  license "BSD-3-Clause"

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libbsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "79895319485ebaec45a16b10000c6b7c7879d2729eed0982d2920d11f46bfe1e"
  end

  depends_on "libmd"
  depends_on :linux

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "strtonum", shell_output("nm #{lib/"libbsd.so.#{version}"}")
  end
end