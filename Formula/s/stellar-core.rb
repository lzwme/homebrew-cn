class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v26.1.0",
      revision: "427aa39784d731daf86dea822f17af45c3875b15"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d958b5db268188f3c14c31cae1c9bce014846235f37d24410d251fb9025af453"
    sha256 cellar: :any, arm64_sequoia: "98e0f4339779e8ca69a58e68254707beb24023efd7a64a9a24c09cc463f83054"
    sha256 cellar: :any, arm64_sonoma:  "284eb095f3306a2c204e1948d096c8838bc4f90454466732c4fa79669ebdf540"
    sha256 cellar: :any, sonoma:        "bec6b98da50d763dd9cdc738266ae74eda1a912f8207e449cc848451d8288991"
    sha256               arm64_linux:   "7c9000a4f71b258221b1d0ac147f2fac81e8ace75b2234ce4b43bfd589c930fe"
    sha256               x86_64_linux:  "a92346b24c724c4ee0402d71ccbbecd96373856dd58d2dff4cdcf6fb70354c44"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"

  uses_from_macos "flex" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
  end

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    # remove toolchain selection
    inreplace "src/Makefile.am", "cargo +$(RUST_TOOLCHAIN_CHANNEL)", "cargo"

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-postgres",
                          *std_configure_args
    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
    ]
    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end