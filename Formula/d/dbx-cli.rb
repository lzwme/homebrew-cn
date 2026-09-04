class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.79.tar.gz"
  sha256 "575606954ba2e31f7c362ae619d457f5af8ad0e3792ab906bb44e2e02ab020d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "766644f78acbcde92f000e576e42bc489d70339bf671038eab1349267a4520ff"
    sha256 cellar: :any, arm64_sequoia: "448192aa117f51ecd7bb1baa329d31591b055dd13f96e47610a6f6ea25966ac9"
    sha256 cellar: :any, arm64_sonoma:  "00a65bbe71d60013f98456a31658cd3d0658681255b5f55d8050eafed7c30b1f"
    sha256 cellar: :any, arm64_linux:   "9338b75119883e29e1c528929525229a6496211cecdad15bd513f99a7bb9c5dd"
    sha256 cellar: :any, x86_64_linux:  "3e27cc38d2a2c1d13abfb1f7f774bf6a5ab2a95b06a1bc15926d9d70e5ac4b77"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end