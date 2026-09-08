class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.81.tar.gz"
  sha256 "94cce32c93c13975f9cde32aeedff20df0d75a4c3823bcd1024a049afe53438c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f445bd64fe2209d5f6846783494edbd20146fb3f1c007f9475e64ecce35f81c6"
    sha256 cellar: :any, arm64_sequoia: "71d47e2121dfb2b5ac279f1183f2a4adf05bf5e5da8425b625ca6321d9610dd2"
    sha256 cellar: :any, arm64_sonoma:  "301684916dcfbd0f86cbc3d4b8fec7b21305765b013b975ef9b902fdb97d0ea8"
    sha256 cellar: :any, arm64_linux:   "7c9552f7797b7082d1c9053dcb7346e4df48c253cb63e800e79b5adf75027ad9"
    sha256 cellar: :any, x86_64_linux:  "37f088c809b95ac825593eb499dcd634adfbbbd48f8031a9cef5fe70da83a59a"
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