class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.75.tar.gz"
  sha256 "6d1b8a9271f944c243fbf829febe2e900ab5a31a198ac788d8e1f2239f2719dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b69fa71fad72dca2fe4fb44f5d2adb4dce927e5647bcead01bdcdca5e22f7a7a"
    sha256 cellar: :any, arm64_sequoia: "035f56d643d1d43d043afb2951b9b3a704efde8903bd175e3211a8209ff2d8c5"
    sha256 cellar: :any, arm64_sonoma:  "f4e828778c6cd9ebb01a3c074a08ea13a5cf4639fd560363941e1fc464ff0c70"
    sha256 cellar: :any, arm64_linux:   "8617f4cfc3dd188dd2794b365fb2088045e446f00045c15c8638d6b1316e9b76"
    sha256 cellar: :any, x86_64_linux:  "6e4ad1c10264fc38e3884d27ac50e0439c030d05442e42aef5ed166622dcad8a"
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