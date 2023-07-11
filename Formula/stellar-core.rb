class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.12.0",
      revision: "2109a168a895349f87b502ae3d182380b378fa47"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f17fa6b94f6372138a747b713f22ffa7afbb814557831944b47f55196052efc1"
    sha256 cellar: :any,                 arm64_monterey: "6ce79955440b060e7f7dd17f59fc402fe685321bdfeec13559697709e26839cb"
    sha256 cellar: :any,                 arm64_big_sur:  "4664ffc28718c8bf51256e6f466dade6ebe0e650d37c81b666f7aa9c345c4cf4"
    sha256 cellar: :any,                 ventura:        "a20f17f0fadc23a6e90259e091ec916b493ae16c7ef88a1ec7fe710d33fa81a7"
    sha256 cellar: :any,                 monterey:       "1f78b6717ccf1007d617c3e2c429bfbe478e4857a439b37bd192ca3fc874b4b7"
    sha256 cellar: :any,                 big_sur:        "8db2d6afdd6408c6c4e6f44c4ed30e4a4607ce5e7c169f07e574ce112917e56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7774902aefa8cf4eec6d4e5d0323d46989bf3f9e9ecac5a674a5688dbff12c4c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
      bucketlistconsistent
      topology
      upgrades
    ]
    system "#{bin}/stellar-core", "test",
      test_categories.map { |category| "[#{category}]" }.join(",")
  end
end