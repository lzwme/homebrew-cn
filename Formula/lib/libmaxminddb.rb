class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https:github.commaxmindlibmaxminddb"
  url "https:github.commaxmindlibmaxminddbreleasesdownload1.12.1libmaxminddb-1.12.1.tar.gz"
  sha256 "30f8dcdbb0df586a2780fcbca5824300d2365734cfbc464ff306751179ef62ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ffbb17c6726c153b4bc03e29c7e9a6b8cbcf6a5ee5ef7cd5f71669976f1c95e"
    sha256 cellar: :any,                 arm64_sonoma:  "b40ceae04dc452083b0433ddd4a7140f07161edc86011cc825396e0be5ea8fc7"
    sha256 cellar: :any,                 arm64_ventura: "d920a8819e4acf730919982f56530ca0ddfc30393ba13008ec755e0e9ded60c3"
    sha256 cellar: :any,                 sonoma:        "2abe0a47830d9c59f6ad0d3654911046a8caf6d498b2f0387fac4f28f29ef41f"
    sha256 cellar: :any,                 ventura:       "d18ba104a623ccd271751a3f897b5cdee8d41ba33160d3f7416913b679120c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3573469c931c658ca3bcf5199c7698a1750b075a79ccfdbc9dee49d9f651f0"
  end

  head do
    url "https:github.commaxmindlibmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system ".bootstrap" if build.head?

    system ".configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share"examples").install buildpath"tmaxmind-dbtest-dataGeoIP2-City-Test.mmdb"
  end

  test do
    system bin"mmdblookup", "-f", "#{share}examplesGeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end