class Libxscrnsaver < Formula
  desc "X.Org: X11 Screen Saver extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.4.tar.xz"
  sha256 "75cd2859f38e207a090cac980d76bc71e9da99d48d09703584e00585abc920fe"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0b3b6f538e4e11629f54b74f0603e9fca13439e3ab37ff3899c9081d4dc80258"
    sha256 cellar: :any,                 arm64_sonoma:   "b2b4a894b7f7ee7f077af223b68814ab6c4a4e8d41de227642fbd373de36e0f7"
    sha256 cellar: :any,                 arm64_ventura:  "0a1e6445b137a59fcb7b2abf72065758997cfefcd36e8ba8f9875e52bb01fd3c"
    sha256 cellar: :any,                 arm64_monterey: "c04b841bd76e8d06c9b37ae51c091ee1724d7b72df939cc8361bbe0441d4166e"
    sha256 cellar: :any,                 arm64_big_sur:  "75b9fc38234ddaf88aaad59f366053812401497beebca2bbea4d69afcf228083"
    sha256 cellar: :any,                 sonoma:         "7f3bc86175531a13ab81be6d014a90ea1e63b4c2ae5ce1a0216c9d994b664edc"
    sha256 cellar: :any,                 ventura:        "2ddac267bc14039812c5c7af3af9732d5919ed7b9a873dc5589613f69c106b0a"
    sha256 cellar: :any,                 monterey:       "28b52ebe202f8695e20fbb36d7a66cbbd9d22a4cffa3339a4903247707a18cf1"
    sha256 cellar: :any,                 big_sur:        "a2a6fb8407b5aaebe67b79704c480a1466f3473929291d2416fb36b187a7b552"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f2b3344d7cb09968e07f68f26e8451f3b67b374e640b5123680480aa33d33d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d538938eb52738da95c07cb87f895673633ed55667a394991c6847cd62d40c5b"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/scrnsaver.h"

      int main(int argc, char* argv[]) {
        XScreenSaverNotifyEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end