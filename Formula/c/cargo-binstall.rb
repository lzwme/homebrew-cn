class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.3.tar.gz"
  sha256 "4b6ce187baa1826001b6122929294e5c873d9592533f44e45f0c529bb26e45be"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "761fcbd51f319d9783d506cdc99bb9b58305ed5baf16adcb2937a513b0e7fd92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a424954048495c0935d3a9f7e299d57ae2c077f4500b547b87d986528acce060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac3e9745e011643b7e8a273f75d32244e9afa7d1348e70dbf03423153e01538"
    sha256 cellar: :any_skip_relocation, sonoma:         "2301f61be9ee99ce7f89a2efaf8c17e2a884ffca3ccdae0b0698a90fe1b4a184"
    sha256 cellar: :any_skip_relocation, ventura:        "f6722deab78ce112086d6b5cb910fda0476d38701e4b3c6e61ba75e6aee4729e"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f8df30e1e10cd27c21c6d2bc82b27523d858667c38ab7e79669e337fba43c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84afadd0c17395003b48dc0a7867986f30d4dc20fdf01b67687981046711ca52"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end