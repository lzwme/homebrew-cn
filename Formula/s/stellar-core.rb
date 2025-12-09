class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v25.0.0",
      revision: "e9748b05a70d613437a52c8388dc0d8e68149394"
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
    sha256 cellar: :any,                 arm64_tahoe:   "59ecfaa7c5b3690057171688e4c60a29375ba48ea7c31d8d40bf1c6814b00ee5"
    sha256 cellar: :any,                 arm64_sequoia: "f4bbbf71e52d535c4d0ea29ff262d5b2337eb4e31abb6c5282609a6e900ed918"
    sha256 cellar: :any,                 arm64_sonoma:  "e0f0852df10b69844f76638d9d6b1a1c25a9d0a4add1df1a5ee57c4b69f2b92b"
    sha256 cellar: :any,                 sonoma:        "ea14435949b4634860861a18f39dee4cff9856f725396ae0246d4f34936d143e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb7ce061ac73fb8cf5b2ecac9388d5c14296cd2e4169884e99feeaebe2b32f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11fd04fb7f4ac9a898eaa10e9b8851d277b2a03461a608d37b2d2c64d6d8b4f"
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