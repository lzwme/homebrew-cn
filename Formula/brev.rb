class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.249.tar.gz"
  sha256 "8b0685955ef5f8c1e25fe71ae5c0003d08d306b84d85f69ef7410f80c08a4dd0"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d20094302fd6a93a5a2dd9c464d356f77d982c7d030efb23850544ce25caad5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4084a2b7a5caaeb336e1073a0c837ec6b781679699f86efba1eb1eb6e782b0e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa22a1a5303ddcb27c031045a1dbcffc09deb5d79559ef586ba9f895940c7319"
    sha256 cellar: :any_skip_relocation, ventura:        "6e732ba71526876da23936ac7155e42c5fb0e453234c0bfd6335ee90c8465370"
    sha256 cellar: :any_skip_relocation, monterey:       "401c4b6ae5c33413faa700a142de4135c0d11d8058a0ed336658bceb7c137542"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bb02e09a3f1631401bef6744cc85a82ecd59590f0a1ab49c2dcc8a2a99250f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced14f422c5c7df97e4e12c8410cb863b625028ff5241cfad6b82c58807c7a40"
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