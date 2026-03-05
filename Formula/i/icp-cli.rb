class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4bbe414eff4abe90f625628e2a4a0affcb7440869ba92234cb153ca68f673e97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b758599c874159eadd8f4a4d6d265f6ee0ee7d3225db4ff4d919b907fa51bc38"
    sha256 cellar: :any,                 arm64_sequoia: "14b570772217d85f4f89a3275d6f7e26632f235d693e8018adbf625b1702bed1"
    sha256 cellar: :any,                 arm64_sonoma:  "1f64e4e225529925128fdc7887e1da79f29c47204b255ba8039e68b107e92b93"
    sha256 cellar: :any,                 sonoma:        "77df5e697d326092b358842209a1e0e96520588b2c2be5b5520ff44e3af52898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48d63029edb04c0a82371f496c30ed770e2aec29b479449f05d94ad626ae42c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033b82653683fa2f534868e38413d8d1ea3d001cb1e72ad6281267d23db72076"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end