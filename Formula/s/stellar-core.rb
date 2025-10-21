class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v24.0.0",
      revision: "0d7b4345de396ad4e8d7dcc4460ddc6feeb27b11"
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
    sha256 cellar: :any,                 arm64_tahoe:   "dce29e72a0bb57c1466bdda27a882d740540ef4bc1305b948de6ffe42e052103"
    sha256 cellar: :any,                 arm64_sequoia: "d555c79aa226165b30b9bd9b3e0052896b705dbf416b1a6e8051ae02e10b2868"
    sha256 cellar: :any,                 arm64_sonoma:  "d419da10be9b8a0ca9179c7c3ef65feb92347312dd0af9e7d2d234b5c7343774"
    sha256 cellar: :any,                 sonoma:        "d67b7009fa8d4665707aa9f295fb6fe31af5bbae0bdd8c023d75431940fbf5dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1786a6277e0fad9d2cd0d60ef15176054062e40d87c9b0e116222758d667a585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d8d44b89881aacef5d46f70a767a958f35986a0dcd2a550be14bf5bb9c8d4b"
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
      bucketlistconsistent
    ]
    # Reduce tests on Intel macOS as runner is too slow and times out
    test_categories << "topology" if !OS.mac? || !Hardware::CPU.intel?

    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end