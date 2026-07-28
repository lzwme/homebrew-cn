class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.44.tar.gz"
  sha256 "2f02365d8730a5a5ef89ed78b740ee1ea814b4525afc1dc8bd09b7d727373de1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c72331886bb3e5c89d14584714d4dfdccb3ded9346bea05a9cbbbd5945414bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b5ec69f286e31a3cba14ed7d847cd45b9f95b52a2d665d0652ab359f0bc32a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265c9f556ee15c2d69ef64e1f5047165b6ea38510e0e9b698011d124bf6bb86d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7a00451d5da196655c4a8566272d7e5e035abb651b7930e76d80d0119307c05"
    sha256 cellar: :any,                 arm64_linux:   "f438751c5f477b2d39167841db823f0bf3e87dfbe1b62626b0a68e84f33f5109"
    sha256 cellar: :any,                 x86_64_linux:  "955a260cb3becabd796552243e57455cfa70bd320e3a7f359a2999713df070e7"
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