class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.49.tar.gz"
  sha256 "00dfa3d10f82c570a27cf990ce2e28f366a570670e81ad908e7b61d717b1041d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b63088e24671df4a1b432d1ee9444572022c363d0a711607ef6cb13653d29cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5366fb2875031de7bee874b08698d63d482653920f4d5b90d1551b38193282a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84dabd637a298f080a7be299f9755bf3e9afe27c75e6b594e30289b353048482"
    sha256 cellar: :any_skip_relocation, sonoma:        "96961616a8cead22a971b99f32d7350ee5e3c443aa928d9899f6081c1874f546"
    sha256 cellar: :any,                 arm64_linux:   "80a062e03baaf2bdcfc39f35e1d78dff0562c574f1ff5609e17fb6cf0f01167d"
    sha256 cellar: :any,                 x86_64_linux:  "051f8a574ad682a7b0f17e08777ef9dfcdb1fae83e11fff4729f91046dccf177"
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