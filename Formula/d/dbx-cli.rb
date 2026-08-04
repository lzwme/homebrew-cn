class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.54.tar.gz"
  sha256 "4aa0b42a5836fdc6cbf4ee05e438f1476ab43e63c98aee765ecccf59f4461a72"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9425fe108d93c67eeaae3a4188b7a0ef47746c0f10bc0f780fbabf03e88d187b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67218b41e5bd3464fece08473601ff0107cd95acef21fabf0b118e5646094907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a943292dfc4a52b0c4ea649322eff8f5767c0abe294bc95d5f9098b170635065"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff5db4dea404b2906590a0a9efa585c95322730e3889945e5fcad35ceb518f1"
    sha256 cellar: :any,                 arm64_linux:   "0b315cc54985ff5165db301e650628177cb932eb97f3d28fc05abee92cd1ddbb"
    sha256 cellar: :any,                 x86_64_linux:  "285a3ef7e43023d246e2c5a2160f9ed2e1a7cfab72245d8e49ce240ff0a7b52f"
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