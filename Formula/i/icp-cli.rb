class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "ea4f3790d2192fa0f4caa16dc73f01d9204ab8e5c872af775896b703d15dd14f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb5498af773b6288bc60748ecd9565ab25fa7c2a75aa6827719a5709dd2de692"
    sha256 cellar: :any,                 arm64_sequoia: "bda13e1d50e59744104ab1cc7d771af40b2ad28a180e9c8c4ec511ee25140bdf"
    sha256 cellar: :any,                 arm64_sonoma:  "945d5d9e0734ea411eac6af8bb1fffb521e7cb57a2d15a06f3d345e6b73b4595"
    sha256 cellar: :any,                 sonoma:        "7a1041f77ed47e19e9b6e96d46e1d5a9abef46f59cc1a62f75c38ba2673aa0ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5147f02ed2bd835816916bf60e10fca981c0c85e06905d2991c38b58f68573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69ff480298eedbbd6193f9f419f3e4105dbca3e7b795c53553c618b6f9857e3"
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