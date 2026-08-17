class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.64.tar.gz"
  sha256 "39f5172b313041a1f03066585c2ecb6504c4f29160635efcb2860f5ff87c27a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4439182557469e84998aa2f0606f58db6d426fe916fa37baca314cc138dcf92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7e2fbcf7bc066b3a79d1cd0aed9488430deeb6f2da1df1643ddf6e4e5f75b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91bb51662f486120561112da28d8fad398d68a25ee3f309bfe2a2c785e72436f"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d5a5521d4748941e8e9233bcdbd67d4847c0296e753b115eeedac948e0be91"
    sha256 cellar: :any,                 arm64_linux:   "9232b48e1f97f5160ceeb5c0621dda1aec9e2dcb5ed5d2d5cef3f60675ab6cdf"
    sha256 cellar: :any,                 x86_64_linux:  "bc5fa281dd9b730de530007c900ba0a9355a40bd5848c0d2d53924fdf8e182f1"
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