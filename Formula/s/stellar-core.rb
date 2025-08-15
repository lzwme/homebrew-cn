class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v23.0.0",
      revision: "d5cbc0793d6eab25eac886969c5bc0f7da69d6ea"
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
    sha256 cellar: :any,                 arm64_sequoia: "25f836e4e8c0922f3f6f2d5b09beea96eec5a4b5b51921f39db85b5004a9960d"
    sha256 cellar: :any,                 arm64_sonoma:  "a9f02274a2579c0bf965da0756d3fe84e93771c265d3a309a1f485ecda87ff38"
    sha256 cellar: :any,                 arm64_ventura: "1779c183d7498959faed624d9e3d83dd36dfb34e5db4d4c23d54c832f0f42128"
    sha256 cellar: :any,                 sonoma:        "40230de2c404d024795ea086064dded6935d4692a68e09efbf4c750800ac5cb0"
    sha256 cellar: :any,                 ventura:       "40e635fe813159b424d16ddb55f390eb91fb3044caa3749f36392aa368126239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec29eba55deb9e29669ae3502769d064a66ce6f2ba4b186035f39e6c68a641d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a315f97c1101d5e690b242201c428ba58ab8c76ac78d0a82d0a0edbce0641e31"
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
  depends_on macos: :catalina # Requires C++17 filesystem

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