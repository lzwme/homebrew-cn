class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://ghfast.top/https://github.com/appneta/tcpreplay/releases/download/v4.5.5/tcpreplay-4.5.5.tar.gz"
  sha256 "ba37b6c9270fcebe86b83f68c4ec3d5ac8981f8c6087b582af0205a35ec4b11d"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5ab07902d826a54e7b02dafa310abc84739b1bab8ec0fb999551d02b38938097"
    sha256 cellar: :any, arm64_sequoia: "cddb61bae519490cc6a92bc54dffb98dd7d734d3af092611efd7f999b9685d02"
    sha256 cellar: :any, arm64_sonoma:  "e49c15c7398e1e2f0464103c2aaca8ecfa3e44c7c70fd254b55fbe335d1823ea"
    sha256 cellar: :any, sonoma:        "1860f849f42face97618c1af03316925c7475860bf3643dac8610e8b62f0f7c9"
    sha256 cellar: :any, arm64_linux:   "ba833972a7fa8cefda6373b1d4b93460a07ea781254e09659813c95a037dbc13"
    sha256 cellar: :any, x86_64_linux:  "f2f131c5bada7f52c9e6b7c9791117d9988ffdfac3800c698d36d6df7e9e7610"
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