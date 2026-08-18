class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.65.tar.gz"
  sha256 "55214d424fadaae7fedbd9aa3186233563fba2f2a66f4679a506f75dcd736e0e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55bdba74b2ebaa7169e5a4bb5e18168020b90c1d343c119c008b62dbf3cb5d3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c8d378877f95925a344e0aa1be6b9521a93b32330138a492206c18cdb6a8d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "644254100cefd22e4b1032f3a8181c18340dafece27ccca6f15cd33ba19fedcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7d237cda87b2d52c032f30de4243a28a5b54030a595da78ee1d0ad83148641"
    sha256 cellar: :any,                 arm64_linux:   "8c5d51728e0edea69114ffc87d8760f8ebaeca58b2d93addaa1d10bd9d5e12cd"
    sha256 cellar: :any,                 x86_64_linux:  "f5cd1af2ff9a4b8bf7ba32f3fa33c0682a02e74bb9c622b04adb3e1e87558520"
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