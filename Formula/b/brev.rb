class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.264.tar.gz"
  sha256 "f3ef1308e87fbd79d2a47ccebd63329ca9c81d80250ba16fc416bad760d023ed"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a00694520b95284be39c1b6116ba3261fefce193ab18ecd8a424e88066e765ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eae6fa65cc156f7f081c46d3bffe8f701a67c5051c576c57f76de272509cb3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e233949577cc3412793b001ec0a8c5860f4c9fadf70c84a2a084b8176fe2cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "54a8b36c4788efaf23d62cf652b9e482960d16962ed2e5178c4dad652947c586"
    sha256 cellar: :any_skip_relocation, ventura:        "47d827ebf9571d13b8dade47a46f186a256eff77989e5a3506cccc3782b4f9aa"
    sha256 cellar: :any_skip_relocation, monterey:       "c0f14de5d027b4eca95da92efb2c12e91ce08c38eb84c2d389523587fd3a4426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9738deee460894ded671e6d36569d74421909ca5263c19e3de40830077f868e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end