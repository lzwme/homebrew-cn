class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.76.1",
    revision: "a5c35285577ddb62d5e30b53196f39d39e759c64"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e9d2522a75178075ad7ec58559938f53bce0f07cefbf54445c821601f2704e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e9d2522a75178075ad7ec58559938f53bce0f07cefbf54445c821601f2704e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e9d2522a75178075ad7ec58559938f53bce0f07cefbf54445c821601f2704e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bd1a7f33844f0506f15352a13c71a37507948b5239aac75abe5b4e92bb46507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9a98fd6c3d09a7e9858f66cd1cf27793f3b10a1fe798277644433412328f7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73f352c1c41e9280d202b68f693a140e7f936e169075d88fef8a704c24e34be"
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