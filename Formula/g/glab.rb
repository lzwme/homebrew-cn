class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.76.2",
    revision: "d8e6f27832fe738abd20a2b434f90b37832800e2"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6972c63e3459eccf9603f25fba47f608f2c10e6ca53e4eeb7875a815cc72996a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6972c63e3459eccf9603f25fba47f608f2c10e6ca53e4eeb7875a815cc72996a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6972c63e3459eccf9603f25fba47f608f2c10e6ca53e4eeb7875a815cc72996a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c01d5555359e0a16d37b9f84eb0d1c07c3dd16c61a5fc34f83de75c2a5e39b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6076e46b8dc946cf87decd2f7f0a24dc4d52ab215b2acb70116cb30242f4d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "159b20e1b1e04043a4660edeafc26101bfe2cdced05aa443b6ec754c5c11e448"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end