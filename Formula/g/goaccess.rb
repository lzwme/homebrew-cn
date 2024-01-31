class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https:goaccess.io"
  url "https:tar.goaccess.iogoaccess-1.9.tar.gz"
  sha256 "b11c8cf282c730541f2ac161d3ea3d4ad60bd88af56cc6ae87e4ab0f93378936"
  license "MIT"
  head "https:github.comallinurlgoaccess.git", branch: "master"

  livecheck do
    url "https:goaccess.iodownload"
    regex(href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "d9ce37367d721131839a855375a93bd611d49a2f4731885ea38caa9df781b668"
    sha256 arm64_ventura:  "28102a591ffccf9c097d7cd55d52594c77b4563fb42fcb5a3bd06726c05122f3"
    sha256 arm64_monterey: "e20efb1f609113f24ddc7f867f34e037bd47cbd39a6b3fe1123c4ab76738ffa0"
    sha256 sonoma:         "14b5f88fcd8eb664eeb80458092dda52160abdd18c3d029941ec4ad47f3051ea"
    sha256 ventura:        "24a78d687cb1f9e82b503da370b19679427452795a36497d753f8d85cf4107a7"
    sha256 monterey:       "0cd8b65ec159d6e9421c676523bd01d08485d8ad6d1e5d850813da4b2eceb3bf"
    sha256 x86_64_linux:   "543b2e091dc234a7ccf434724ffd026281d5daec5a98adc2e067d276d3b8431d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  def install
    ENV.append_path "PATH", Formula["gettext"].bin
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
      --enable-geoip=mmdb
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]

    system ".configure", *args
    system "make", "install"
  end

  test do
    (testpath"access.log").write(
      '127.0.0.1 - - [04May2015:15:48:17 +0200] "GET  HTTP1.1" 200 612 "-" ' \
      '"Mozilla5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit537.36 (KHTML, like Gecko) Chrome42.0.2311.135 Safari537.36"',
    )

    output = shell_output(
      "#{bin}goaccess --time-format=%T --date-format=%d%b%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>devnull",
    )

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end