class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.100.tar.gz"
  sha256 "4d4f4a7e9aabd939e3632abcd79aed9bfb22dbd204468f533d7e60d197f3a145"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "095bf00daed59882ad5c5ce972adc386993109675a2c657c2f08d927477be4ac"
    sha256 cellar: :any, arm64_tahoe:       "ff7f12b51ba98421658593ba8d4670f66fa92cc29317c255523aa8505598fc79"
    sha256 cellar: :any, arm64_sequoia:     "ec57a8e3346bc7887b6fb526e79f399d4034f38a3d24a71710aad5eaf9fe71ba"
    sha256 cellar: :any, arm64_linux:       "a08dfc7a029aeec42c3e98de902266dcc58990982ba56dd9f9d70748b49a7789"
    sha256 cellar: :any, x86_64_linux:      "ff635e566a278f4991e24466be3784e961427c740a98ba3fa7654a7d92e53030"
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