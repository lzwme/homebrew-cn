class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "62c371ea443217759eb5f784182f16414a4615c11c800c9b824059a1f41b2102"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39fd6cd129287585cda077a517e27726ba75714cde939b3d5a127758d11f7b16"
    sha256 cellar: :any,                 arm64_sequoia: "5ae325071c3bb64b6e5c89133cf3570aa2c1f6bc59008ad7c6df8d8ad0c4ba99"
    sha256 cellar: :any,                 arm64_sonoma:  "948ca8a5424eab628a28f57aa3c22f99fb825aaa6b4519655c17bcd24d90d764"
    sha256 cellar: :any,                 sonoma:        "a41f7cb8825bcf24f64dae0feaf7178c2f0608a2694032eecdae123181088b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6215412898ee87b1e1e6f40e8ba98c977c832767e43cc6e92e931603744cffb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78a1e7c2ee4dc6cb9d42577ccc319ecc3b11bea721cccfe739fac85f43f1aa6"
  end

  depends_on "rust" => :build
  depends_on "ic-wasm"
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end