class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f7c36d262557d79f4b506f28b5e78769f6f62cf5e18e3d52e2e939445412d227"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fdd1af1bd8c6c5ce7e9c3d8f3123f5527c636617f382c41faac0a340fbf16f66"
    sha256 cellar: :any, arm64_sequoia: "418d148efd2cf32a9f0bd0670f37d6a79f971d1dbff804759b2367a10d4d2284"
    sha256 cellar: :any, arm64_sonoma:  "55b555acabe7d189081914ca4e4f86599819667b7a09038f1591455a86f0cd28"
    sha256 cellar: :any, sonoma:        "e66c32edd21a1c19476a170ec66c7f6fef046d8ad6733670cc0cd498125b5b8b"
    sha256 cellar: :any, arm64_linux:   "853336cc6f6707bd8e8c02947b276c7f1c01a145bd9c031716080581c16a2ab6"
    sha256 cellar: :any, x86_64_linux:  "11d9e6369f450d34af3b057948fb77581daf8b5a369e07ac7d3a1ef286daac5a"
  end

  depends_on "rust" => :build
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

    # Skip wasm32-wasip2 test fixture build in icp-sync-plugin (only used in tests)
    # https://github.com/dfinity/icp-cli/issues/543
    inreplace "crates/icp-sync-plugin/build.rs", "build_test_fixture();", ""

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end