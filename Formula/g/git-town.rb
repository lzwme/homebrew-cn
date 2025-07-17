class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghfast.top/https://github.com/git-town/git-town/archive/refs/tags/v21.3.0.tar.gz"
  sha256 "3068c5e40de3cea985a304d1e0b5c2b6c89017b2ffce26c58d9d4e089279eedf"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c2bd41c4c121b0c1f5fb4a115592021ec319c15ac2f10d8546ca55cb996894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c2bd41c4c121b0c1f5fb4a115592021ec319c15ac2f10d8546ca55cb996894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82c2bd41c4c121b0c1f5fb4a115592021ec319c15ac2f10d8546ca55cb996894"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52839af3bf5d5810464f6b48a268c5582ab0fd7fdd1a6296bf832f48bdd20f3"
    sha256 cellar: :any_skip_relocation, ventura:       "f52839af3bf5d5810464f6b48a268c5582ab0fd7fdd1a6296bf832f48bdd20f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1aa04e30e7b4387c62206a56d725c55262831e8d6e9ba2864916621b69c609"
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