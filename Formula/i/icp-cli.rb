class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6156cc4463e7aa97e4d6c55025ad9b39014dd646b5268cf76168167f1ea8ba06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9645d07b7413235cde1541f046947a24148895ad07c3ccaf37c970ccd819b254"
    sha256 cellar: :any, arm64_sequoia: "0edea1c358b99edf7a50d5ddd2df00d793ffd239bd985aad0f92b56c05323b13"
    sha256 cellar: :any, arm64_sonoma:  "8e569291b1925bd9bac139b110596abfdcd173672787cbcf4fe2628fbe5f71c7"
    sha256 cellar: :any, arm64_linux:   "2ec625e91940ee8fe3902fb59089718d9dc66e5822eb9174d4f3ecce28f7d372"
    sha256 cellar: :any, x86_64_linux:  "3db5004ddaad589a11b64830b25d034b852507a76781f6e7e461b87861d4080c"
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