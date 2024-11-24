class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.14.tar.gz"
  sha256 "1894e16ffc7b4431605e24b166469f24b6ed5a015cf4d7ae91983520c9bf98ff"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff3e6312a451c64ac0733c794ab9cacceb5a5b150a7d044edcb91070ab4c801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19a2a9c4ef6452527ffd4e52b48fc234cd3ffa3fccff33b2ea2611d689971da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "761c169a470a68ab6e5ec7e8b397fbdb83b01b317a3bd34472064a8d9806d6de"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf18ee7bea8bcc5905ab14c5836ae294a55e9fff1c76948ca23a80dad225c312"
    sha256 cellar: :any_skip_relocation, ventura:       "14d4f28511e550017d55e09ba15b7c55bea22f5a23193a24fa7ac2efd59ad15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d95c582e92886132cbe76a9162ae36e7cfaa20f711a6cd699be4bc61a1bcca"
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