class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.60.tar.gz"
  sha256 "ed28ff49f939f7cf64ca113a35dc74cdc4e4174071c99b258170de1b117cbb02"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df05c7bae8f1853460ee6b5792cc995ede648d1cea3c9ec1ba75d3aeb957319c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323ce2378937758927fbaa78c41c8758987ddc256513112e778487b5870d2524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c6c914001529a37edf3b74f8a4cb4ee2699fddad09fa16f6a1fc1c46cd3884f"
    sha256 cellar: :any_skip_relocation, sonoma:        "626fbc1f11d496bcf1caf374a7451028a9fdd9a75072a5cda529de67c40086b4"
    sha256 cellar: :any,                 arm64_linux:   "55f99cd9e38cc33e35bf8827a9abc7b5b9eaf074a46431a113d37b2afe5b0b4a"
    sha256 cellar: :any,                 x86_64_linux:  "51090ae4089f9b870ab87cd447a3db16c931449b538d805ab59416a618e10c4e"
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