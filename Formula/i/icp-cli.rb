class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6bb4013895e077ad0a51efd8e9639bd82d4c9d364f27169a7df17fda4ba6a709"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2f1cf2897c761e6b7ceb23f701e989a12a383f3f428aa6f345ba7b61b463616c"
    sha256 cellar: :any, arm64_tahoe:       "9c5301855f0e6d57726b9c84642290c1d849c10af0d5e7041c64744ed8091339"
    sha256 cellar: :any, arm64_sequoia:     "ebe097dbc3ee5cc82d987738103fbfaaf2ae3c78324daa1e14f0b5c599db4666"
    sha256 cellar: :any, arm64_linux:       "15564ce13051d357f33eb434b48093c00b4d2fc0f21e748d7bca1fa8a0e4c6b4"
    sha256 cellar: :any, x86_64_linux:      "ff8c8460f898f79ba35687969a1e3d5abc21817998629b09899ed2b4063f8f07"
  end

  depends_on "lld" => :build # for `wasm-ld`
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
  depends_on "ic-wasm"
  depends_on "openssl@4"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER"] = "wasm-ld"
    ENV.append_to_rustflags "--sysroot #{HOMEBREW_PREFIX}"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end