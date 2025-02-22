class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "https://x3270.bgp.nu/download/04.04/suite3270-4.4ga4-src.tgz"
  sha256 "075e8ab0a1a901d879550629bae59b73ea8aed2c9b4d38c14d79c72e0cfbc07d"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c8d4e2ca525793a35b138372d394c8219ac247314d31fe7fbde494d0bb20b5ea"
    sha256 arm64_sonoma:  "95472ae345dc2591ba5896bec6f14c07bd59040f44748a4215d3d1a00881e7f4"
    sha256 arm64_ventura: "6f2a137b7f813429169957ecf0327c6b708944ce82bab84342f05c1fda28d8b5"
    sha256 sonoma:        "28a8ec4ab0d4f43d1f37b5453f64bafe38f72e24f8280b3f67b6b0b0a210fca8"
    sha256 ventura:       "112ef2a0be9ca1ae41d8a8949cc9d2a161247c97d718c2d235223e155d33820e"
    sha256 x86_64_linux:  "1aaf147804e1a41c7646f248f7fb32543cbb5bce2a0c71018b14c4278e59e7eb"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "python" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "tcl-tk@8"
  end

  def install
    # Fix to read SOURCE_DATE_EPOCH as an unix timestamp not a date string
    inreplace "Common/mkversion.py", "strptime(os.environ['SOURCE_DATE_EPOCH'], '%a %b %d %H:%M:%S %Z %Y')",
                                     "fromtimestamp(int(os.environ['SOURCE_DATE_EPOCH']))"

    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk@8"].opt_include}/tcl-tk" if OS.linux?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end