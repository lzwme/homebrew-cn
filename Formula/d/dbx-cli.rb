class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.45.tar.gz"
  sha256 "36d975f318ca551961e6d45ac56271ca7ed3e14e4a4787904499091380c3d7ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e963d6e90cb9f608c4200963bfd3af6826936fb090f436acc88ffbde198372c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a38257ca60984709ed911a75c79c5d09beefd7ccbc282c3ed2a8eac6fa325d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38922c7f2424efb6a69159d99cf89f748b81dee029bc3d8e28fa879537e0027f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b99f1b27b5533efe3803172ea8c317aba0044ec5238252e3447bcab8f8b97a63"
    sha256 cellar: :any,                 arm64_linux:   "3b0ea6676f76c4c32ccc06061db816745172cc10e5995feb3ab6fb96bdf33078"
    sha256 cellar: :any,                 x86_64_linux:  "f41cea4bb0f3df5f56a33656462472eaf46171adc1f2cc564c5e8b2dc6b6aaf5"
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