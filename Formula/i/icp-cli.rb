class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "a72ce6e4ff6b6f0484e245aa036d8f4446080417964f5155e81428ae9a73edd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37fd5de1c3ec8aec8218a9760369f53693dc9292b9f5f80688f97c1e176b23e0"
    sha256 cellar: :any, arm64_sequoia: "33b1fb868c7db5ecd3d4e259ceadab60e3d42710441c726d8258c38a7d8cfa5b"
    sha256 cellar: :any, arm64_sonoma:  "3a86689876d11cf3c53d36984acb00263841fc4f4132976157d939014da31922"
    sha256 cellar: :any, sonoma:        "ae34bdb0e542aa36ea698e1f4ac7069c12d481f87afdefddf15a4ec07232703c"
    sha256 cellar: :any, arm64_linux:   "3b45b4646efc4962b69eec7b7297c20e2da75bda392198fda8db95c690fd7b50"
    sha256 cellar: :any, x86_64_linux:  "92586f6be942185a849b08e93b63c16aaae4f8edcb9a771ad69a45342e179c22"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix

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