class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.38.tar.gz"
  sha256 "75e1100e3f6308dc5934f37d4a0f45cee0b7d2bdb97e88f9ae606fbb639da0f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c80a3ab60e95ed0bb4de4fcbd9ce8984e3715ee18f9d19f3e627314bff7654bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a157ab12205ee9488fe6c615dc80bd5229ffabc001ac7bd1ef0a16275af9ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "837060394f6d5ca00b61cd1dff95410f04cd66d3b9b6db55b260d33a19eb452f"
    sha256 cellar: :any_skip_relocation, sonoma:        "91e9055d3d4456f067f7f30f43ed566716a518a4188f52b379bead1fb272a6ff"
    sha256 cellar: :any,                 arm64_linux:   "34089a5b6763cc68b4e5051ea354602b2add3a93b3a98272bfc2d9cff06fb931"
    sha256 cellar: :any,                 x86_64_linux:  "d5f875e0a4be001d7eb8b431ab3798335b7fe86c0a5ed632d53713799fb59992"
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