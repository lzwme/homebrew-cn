class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.10.0",
      revision: "bff2c2b37402acc61166c0f369da1205efbe8c9d"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7a9d381e908d037fa9629d3d2bba6d4f161f7f13cde4365a2e057cfcd650d3a"
    sha256 cellar: :any,                 arm64_monterey: "768948c47b97ef516f4cc79240ce39ff030ccd4ca4578253cdd9011756fa27a8"
    sha256 cellar: :any,                 arm64_big_sur:  "3bbf99df73e334c1b84dc326ee77969bdbc07808a3b8e392902e148c51b8457d"
    sha256 cellar: :any,                 ventura:        "360a2ae78da941995d1179bcdabdf90b65974bfe7e6e753f7ccec7368c196b08"
    sha256 cellar: :any,                 monterey:       "9f4015527955bdd61fc2018ed398867bcda1fafc5c8c4a0ca221cc8980ed9078"
    sha256 cellar: :any,                 big_sur:        "370a86e53cbb5460c5f5cc75d17482df1c291c72fc3ea50573fe0c64ce2d9d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c2a0d173d06b05a0cfa6c88b9915664dca04d3520e1ed5ec467e28c1599c77"
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