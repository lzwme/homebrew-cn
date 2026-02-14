class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.10.tar.gz"
  sha256 "79c22a1d6c7fc299e368b89f9b6c4d348fd36d27cba013b76429d59d19ccf56a"
  license "MIT"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "85edc7a6cdeccaa9ca5ef1afee4a0993e36327b05ac9800eaadcb392b15c6c2e"
    sha256 arm64_sequoia: "d524d9df9c3f095efa4c0b681fb90c7008a9dd724a6f5ec0e804ce3d100bfc06"
    sha256 arm64_sonoma:  "42b3330134395ce6467fea24aa368940bd09a29d2fda263508235f3be22d5a80"
    sha256 sonoma:        "314ef7bbd14866132ea453d24917c95b077e7b432cd6890187f31e05af3808d9"
    sha256 arm64_linux:   "bd5eca236ba7d9db922ae43490732abe90369daf65560a36631927721209db01"
    sha256 x86_64_linux:  "d1d16063da26af6700a9dd7a58c88b0b4f56358bf019dd1157deda862de68998"
  end

  head do
    url "https://github.com/allinurl/goaccess.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "libmaxminddb"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      --enable-utf8
      --enable-geoip=mmdb
    ]

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"access.log").write(
      '127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" ' \
      '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"',
    )

    output = shell_output(
      "#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>/dev/null",
    )

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end