class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.58.tar.gz"
  sha256 "0f2c730208317403c9526a021fe38112016d58c6b2b9266eedce47dce48a1d41"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13d2574f5bcfe1cf7081cc46403e75ab96fd210b2b444b8ec6b2324c3cf7e627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3411a1e528fc67c925ff78d2a1d32e71fafb6bd2052c3aa69da09b6fbc31acb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "059095c9e757e7915a56ea68d4d17234bd29613916d6fa0b0072be6803ae150b"
    sha256 cellar: :any_skip_relocation, sonoma:        "33735813e380ce97fe1c32790bc3f02aab214a2e0fc2de595b2b0d911c46b188"
    sha256 cellar: :any,                 arm64_linux:   "620a8ceb8b90e436eba3c6f5b99cf186494ecf2777c0f13a998a7e8e13b3eb04"
    sha256 cellar: :any,                 x86_64_linux:  "189df6db34aee620d67b13bd3334a537dbc6c715a354075cf41df086d24f24c1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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