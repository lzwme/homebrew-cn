class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d89641bf12ba124529ee7b39749042a98926e71164c81d29912b035ed0212396"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "64e8d1f7de4744d64de307ced301788cde344fc4a9aecfcf136729f709e1e9f3"
    sha256 cellar: :any, arm64_sequoia: "383573ba1c43a8043a95f54ebc3c649141815ea1319b997092150fad2ccafd53"
    sha256 cellar: :any, arm64_sonoma:  "6f3344cdc9b0b166ebbe6ce1d02fd12c70808b42df324e8e2a8b0a26cad1b884"
    sha256 cellar: :any, sonoma:        "1b70a535eddd45586a3d3587e9590a7b0fa189b1f65b057837ff0baf576dd336"
    sha256 cellar: :any, arm64_linux:   "751ed1f1a6ad365cc083b769592be5f5672c12081afdc08ccca7bf9b2963cc51"
    sha256 cellar: :any, x86_64_linux:  "931fdb8922dc28ae3aa4801aee2a193cdeb9d2e824cd8d9e630eb498f2a7edf4"
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