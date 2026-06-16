class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a46550528496f4229287030c29e65854c7b39a9c77be4e40f1e9b31366ab18a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7558a1bc4e0824deca268c7693c8a459fb3d2750f39840a03baf01918b405577"
    sha256 cellar: :any, arm64_sequoia: "6ce0973197ed9733a14fa771e9f5d71b9f7429f985ef165f7cc2bcbfc446befa"
    sha256 cellar: :any, arm64_sonoma:  "2850a3c8c3b8fe443450a1a1499b655b101de4f9ebb95bfde27463a6762409a8"
    sha256 cellar: :any, sonoma:        "3da46f7b6e8c737b14136aa49593688766b00dd6b73aadb1bdf1278135af68cd"
    sha256 cellar: :any, arm64_linux:   "226f96356182b26819c467b7b84c724481bceac8f27752679df764a6df200e7e"
    sha256 cellar: :any, x86_64_linux:  "b5a5f125d347ded3f99fa0023b12e700182c0e3292a236645344ba424dbaaa0f"
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