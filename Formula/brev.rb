class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.246.tar.gz"
  sha256 "41364b109ccb7b1181f3d3fdfdd4dd564b93b29b4eda458061e4f7b06c367997"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e3e33ea4b97b69a1b68ece4980d92471bb4fd248f60a2e28cd491a5ec5d663e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee336e705c91dc5afdb1d4aa0acf096b4af307bd96a37150d359ef6fd6c1b0de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f277a6772c9eb2d2df138a5acd4ee1a7788650f7f05050b0f53d65b619497d9a"
    sha256 cellar: :any_skip_relocation, ventura:        "d2f20783bdc85980901e85bd80e08e4d1aca813112381fdd0f48df8fbd304cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9ee4886777635a808b266ddb92291855ee84f58ca208c363d2e94d5daeae2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f600b9b1baea818a5d6a0f30a47fb3efdbd824034aa69b74896bec53c4c4f5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b10407d93bd106cc1135cb42d8e78cf0a5eef6c73820fa8dd0a77d7b9c7ab0d"
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