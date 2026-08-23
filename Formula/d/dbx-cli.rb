class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.70.tar.gz"
  sha256 "805f74afbe149ff1dfaa4faf2cfb39b238aca43cb3bd3e3b811084e3f64e69d8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "55152c6cf399abf5c54ff4a300cbb8b389504bd24dc3ef867be52962ecc2b3d1"
    sha256 cellar: :any, arm64_sequoia: "6977a49f3a2c05296ca29f001ba8711daea6ba166f64f923539424d3a505320f"
    sha256 cellar: :any, arm64_sonoma:  "599c0def75fc2c61593a561d007da5773f8457c3e38e254de6b9406632dfed87"
    sha256 cellar: :any, sonoma:        "7041e9882bf373fda2d8a0ac58d04efa9759460f9f1c73a6f2d128017e55ddf3"
    sha256 cellar: :any, arm64_linux:   "53e3f365d754a0b46c9df6e6ac2356b4ffe8d5dff000d7ff58eb867529a7ecad"
    sha256 cellar: :any, x86_64_linux:  "1c487945747354136b597b3aa8b8bcf26adbd2454e04e934c12a860151a9ef38"
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