class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://ghfast.top/https://github.com/maxmind/libmaxminddb/releases/download/1.13.2/libmaxminddb-1.13.2.tar.gz"
  sha256 "2c7aac2f1d97eb8127ae58710731c232648e1f02244c49b36f9b64e5facebf90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e04fc06c05a47561694a0595748bbe4ffb4be1555126dda44648e2d7cedc32c"
    sha256 cellar: :any,                 arm64_sequoia: "b1bbea330b874e9c07cddcd5696097cedea6f6876be09e8adc1139e9937fecc6"
    sha256 cellar: :any,                 arm64_sonoma:  "f0be5d36f842e54ee7080d0827e681ca919fea8d806c4f4e99c47789e71e0db4"
    sha256 cellar: :any,                 sonoma:        "ef2e120d3c68c063c5a3d69d5d31e5ca025f58f0ff270b74f25ba469b5786737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86353fbb4bb3fedc3933c71d1f920ceb1a00d3660ea75180389bc9504138b1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6e38e8b1890b6c667f79530c86d7000079d2ed1388f6922dc1eca87c7cb564"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system bin/"mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end