class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.50.tar.gz"
  sha256 "c0bb370384ca457c0da173afbf34be123f8bbc5f8a311e706239ef30dc7ddc5a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c22d3dc4f7f2477c17683305330585967c4b610176ca2d7d526a478e81cb813"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c18ddd1a528e8b84609fb2a9966c6b6b85cb35bf539cd7be70b0ccd02d2a4cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155403a8e8298a9eb625b3e71ec443bc811f305fd7e0aec525bd022c317e0094"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4a685483ea79fa12c29d1d0666af5f06297a1c5888863a2555ce3f7e0b129b"
    sha256 cellar: :any,                 arm64_linux:   "6ae86b14746003167759f5759c07b362fa45fe643551b79ee924e4d8c291a8eb"
    sha256 cellar: :any,                 x86_64_linux:  "dbac0ff76d95f23f0403a569d0853e017bf7985f3c0ab96fb1ca3430e61640d0"
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