class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v25.2.2-external",
      revision: "1a44083a0ca3781737e2492a2e4774316f5d7feb"
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
    sha256 cellar: :any, arm64_tahoe:   "d63d2a65b3563b7c06649bf5b291c2ee3c046b8f245c45c2775c9e8561dfa8c4"
    sha256 cellar: :any, arm64_sequoia: "4ca8376aedb8f98893fa91476d1fba61f8c50eecd28a08aaaf839f895dd1c0cf"
    sha256 cellar: :any, arm64_sonoma:  "1d2c33bdc9f4cf810ad8a31645a67f848880080e8b431c64bdcf8b6758f5389c"
    sha256 cellar: :any, sonoma:        "185d9132b4a455e9854ce7c81e85996a38588f7c73b3567781674d75390730c7"
    sha256               arm64_linux:   "c15d4b0a0b31e5c489650568785b49d43f03f02c7b94823e8cccce5b0d9f1d4e"
    sha256               x86_64_linux:  "0b9e3cc3796e7a95b1967c0b6499ca33e5575b4683376606ac95f7e5228d7542"
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