class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghproxy.com/https://github.com/git-town/git-town/archive/refs/tags/v10.0.2.tar.gz"
  sha256 "045b40f98158192238d0258e706cdac5d547cc92123a5c79118ceb072c2f145e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0234e6be4e3868420536ec9ffb0fbafef1faafca426e317ece1baec779d13dfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cde5400bb20508371b5201618fbc9e73de16d5a9eee953f069864f21545347f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee915630987bf429c81fbfb4e78b237972bd00acba94eed15a5f92d194a15d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "de893ba2e0b4990f0e43ef1bf407a9fe6ac608669432d8f7db49aecb3461b224"
    sha256 cellar: :any_skip_relocation, ventura:        "8897b17f6ea62981e45e511fff92ed13509e41149fac47424a44abc86324bd6d"
    sha256 cellar: :any_skip_relocation, monterey:       "ff4ff22ad4940d3df0d20c0151954c09db8c706ddffa05a3a928b3dd0a5d0201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71efbecbfb04c924708c9e832bc12d2e586fef8b477586a2fe605520345882eb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v10/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v10/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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