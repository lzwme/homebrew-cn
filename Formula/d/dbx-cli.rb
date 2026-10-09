class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.111.tar.gz"
  sha256 "4329c07f926d0738775ba43bf8c3531f4d377d3f5f2a36e5dff7207f9a281664"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "96b21872adcdc2060a2a002a342127c42fe52244660862f73d665990de0bada0"
    sha256 cellar: :any, arm64_tahoe:       "1cdf42c7035fb4a1a7922609aaf8175c2333616ac5ec85654b276a8c011c0b3e"
    sha256 cellar: :any, arm64_sequoia:     "9f56408582391821c5157037ab52ad916ed32a2990c16c8a55b882dc4c1507f7"
    sha256 cellar: :any, arm64_linux:       "306b2f9618161deacff24934554c5fd2f888fa62a88cfc668a4fe3038b8908af"
    sha256 cellar: :any, x86_64_linux:      "15da8ecb4bd3efd4b3e5702720370478dd38bc01ca053b82b670db450d52c84c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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