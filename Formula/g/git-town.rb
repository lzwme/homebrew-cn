class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghfast.top/https://github.com/git-town/git-town/archive/refs/tags/v21.4.3.tar.gz"
  sha256 "e94e3d1ffeec7251c914f3c6edbdf1d9e2bd89426184b4d14abb67caa0008dda"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d791052dfdd57d51683ab278a44290f5fd7db0cdbb838eaddb949d274f3858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d791052dfdd57d51683ab278a44290f5fd7db0cdbb838eaddb949d274f3858"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88d791052dfdd57d51683ab278a44290f5fd7db0cdbb838eaddb949d274f3858"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aea8312e4907893564a9907db4fa7fed23d9933d792607098ceb0135baed4ac"
    sha256 cellar: :any_skip_relocation, ventura:       "6aea8312e4907893564a9907db4fa7fed23d9933d792607098ceb0135baed4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8717979e518c1eae4e3e151b63c50d5c9333f018c3cf7ca7d0c99f068b03505e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end