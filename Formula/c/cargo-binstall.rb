class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "f4715778e48d2d112b621e7f4cc5b00d15677ceac65e82cfc028a6dc292a4792"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72677b02cf3a6242271a229acb7055172ab905295d69f496fdd9dbd121d421fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1660033409fcba60a0175b41333d6b7e4072fa499185aa816ab883383f0e3073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a59d4d087fe7793d744d8d219cd4b25dc85165bb55ce0f280a715772d94560"
    sha256 cellar: :any_skip_relocation, sonoma:         "c161ab7e2ab17cb5e659a2c9683a007aa6c8be891b4bf21c5a0b3184ecf02786"
    sha256 cellar: :any_skip_relocation, ventura:        "971d8ee7b1388e7117a972acf8f2d99eb383042bf9e9274013c4ed044299b0d6"
    sha256 cellar: :any_skip_relocation, monterey:       "994b61625e81fe625160b762204977b1acaf5deb455565b842ced10b8a1e09eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a926ab5b9e3e23bebef20467f585a329046155692621793f3f0f19cd9b883b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end