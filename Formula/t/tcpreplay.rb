class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://ghfast.top/https://github.com/appneta/tcpreplay/releases/download/v4.5.3/tcpreplay-4.5.3.tar.gz"
  sha256 "56c053da51d7be1b6d59fa465d111bd224de73ae8bf262bf2078af914ff2e023"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4390017f35baf1f8fbee1294e245f00ca13441687ac310bfd4e26e3f467e4ef0"
    sha256 cellar: :any, arm64_sequoia: "7f4b0b25b1f54ee798f208376a3bf8fa6903733882d4e7fa5183e62ad20ac228"
    sha256 cellar: :any, arm64_sonoma:  "bd2263a2d9f2d0d9cbe73b38b1abb419fb0634873b0ae72cc7e228be2eb68fb4"
    sha256 cellar: :any, sonoma:        "0f3cfa6a764fb74021824e72f42316ed25350ddcded3d5a60f2e5f3851afb263"
    sha256 cellar: :any, arm64_linux:   "004d9cdcff140788618b2543d59f79e30cda5063c5a36931ef2ad47fb09fc911"
    sha256 cellar: :any, x86_64_linux:  "c14c92db90b8114c52c1fb52db8908fc91e82bb185de33f5ae045d9e3493fe15"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-libdnet=#{formula_opt_prefix("libdnet")}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{formula_opt_prefix("libpcap")}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end