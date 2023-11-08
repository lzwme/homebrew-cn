class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://ghproxy.com/https://github.com/maxmind/libmaxminddb/releases/download/1.8.0/libmaxminddb-1.8.0.tar.gz"
  sha256 "1107799f77be6aa3b9796ad0eed8ffcc334bf45f8bd18e6a984d8adf3e719c6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "521b1339a3633c38894496338ad49eb789b82892f214c2ed1e6dd32f2b27786a"
    sha256 cellar: :any,                 arm64_ventura:  "9ff381c1ce80f5628cfacc236097e5dd1d1f8f13de3952188e9e7a4a139ec6d1"
    sha256 cellar: :any,                 arm64_monterey: "d0af8f7986098c131a0db414cefe42fd62c494217e6351344c4be8c8f57f5d0e"
    sha256 cellar: :any,                 sonoma:         "4bd992233904dc15db1433870fadaab47b3d3d88219a6c45634ca12162ebed52"
    sha256 cellar: :any,                 ventura:        "69d73c9c8d2c591260fc9f166d9a8595d76ab2ac022036228971268a1513fe98"
    sha256 cellar: :any,                 monterey:       "edfd191fb66d24b79f7147b85a5d3990eeb8a8ab22ccf4313b8c43fd44e0c1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc291a23acac5c3af31dd738f7746cfcf4540735a101f36bb40285dd198b7688"
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
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end