class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.15.tar.gz"
  sha256 "9570ecae079e587af8767cac183e9ce2667a5096f3ec45901f2df1aa57983eca"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4363d527755881dcb136f651923e4172811e131b47724d619555d21982289a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8a40fd4f64fbe5931c5e5931432e11861a78426aa9e31aa5ff34369b764335a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44c546f448b96d696a3462959e797b76ba0f53040ba5271cc92c8a2b84c6879c"
    sha256 cellar: :any_skip_relocation, sonoma:        "99599ef88a3858a7968a3d005810342562f0820838dd0152ae5ba63c6af3f900"
    sha256 cellar: :any_skip_relocation, ventura:       "139554cef36ec836d411491752be7b249a90887050b7031a2d306c200f76bc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be25723f72a1296dfef8f03e4211ece267d48ffa6ab76b07c4d1081757a78cf"
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