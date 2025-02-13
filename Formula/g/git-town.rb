class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv18.0.0.tar.gz"
  sha256 "ad43a375e27df630666017b8e961618350f6fe83d3eae4267338f0e67f972d1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f0349384856bf6f3a518816e39aed2406e737c99533ac537da17f0e70983fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18f0349384856bf6f3a518816e39aed2406e737c99533ac537da17f0e70983fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18f0349384856bf6f3a518816e39aed2406e737c99533ac537da17f0e70983fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "57756feb05ec793601251c518a12f57e7bd1438941698a7dd13e0759473ea493"
    sha256 cellar: :any_skip_relocation, ventura:       "57756feb05ec793601251c518a12f57e7bd1438941698a7dd13e0759473ea493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0356ec3056c33a7ab6234d3c2efb836123dde0b2fcf2ad602c3dcba928570f3a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end