class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v29.0.0",
      revision: "a9d72b0cac3a89ebbcf926af449ac73089e0f8f7"
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
    sha256 cellar: :any, arm64_golden_gate: "95d56a34a921ea2e23eab49edc58c907b948e6fd522d6d6f4ef90fb5f16413e9"
    sha256 cellar: :any, arm64_tahoe:       "884617cff2757c17589372284b085e9e268a17fe15e1563179fb6e4ff1ea6081"
    sha256 cellar: :any, arm64_sequoia:     "b6918bb7dcf79e47b58c04636148f6a470d93e46c9140af6bf0d673fe76ececd"
    sha256 cellar: :any, arm64_linux:       "de4b7b7a0a2f3de1d326f7d2ba6ff0df349264fe694083a2ff07f59f9ca8fbb2"
    sha256 cellar: :any, x86_64_linux:      "7aa89eedf19160d9a080b17f51974d7d3dc8b8a73081cf4f227a79aa990e697d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpq"

  uses_from_macos "flex" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    # remove toolchain selection
    inreplace "src/Makefile.am", "cargo +$(RUST_TOOLCHAIN_CHANNEL)", "cargo"

    # GCC 13+ no longer transitively includes <cstdint>, which the vendored
    # `libmedida` sources rely on for `uint64_t`. Force-include it.
    # https://github.com/stellar/medida/pull/34
    ENV.append "CXXFLAGS", "-include cstdint" if OS.linux?

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-postgres",
                          *std_configure_args

    # The p21-p26 soroban host submodules lock `ethnum` 1.5.0, which fails on
    # current Rust: it transmutes `()` into the now-non-zero-sized
    # `TryFromIntError` (rustc E0512). 1.5.3 replaces that with a safe
    # constructor and satisfies their `^1.5.0` requirement. Bump the pinned
    # lockfiles and the dependency-tree snapshots the build verifies against.
    # https://github.com/nlordell/ethnum-rs/issues/60
    buildpath.glob("src/rust/soroban/p2*/Cargo.lock").each do |lockfile|
      next unless lockfile.read.include?('name = "ethnum"')

      system "cargo", "update", "--manifest-path", lockfile.dirname/"Cargo.toml",
             "--package", "ethnum", "--precise", "1.5.3"
    end
    buildpath.glob("src/rust/src/dep-trees/p2*-expect.txt").each do |expect|
      next unless expect.read.include?("ethnum v1.5.0")

      inreplace expect, "ethnum v1.5.0", "ethnum v1.5.3"
    end

    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
    ]
    system bin/"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end