class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.122.0",
    revision: "89d0008af1df78a62f5b446fb9b1bfc479771279"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "687b2d458f98f2a560b784b6242ee47c6524e5b672ef2c957a95b76ae9b51777"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "687b2d458f98f2a560b784b6242ee47c6524e5b672ef2c957a95b76ae9b51777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "687b2d458f98f2a560b784b6242ee47c6524e5b672ef2c957a95b76ae9b51777"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e646b22977c83b30ca3b3d722bd2ce064dc8a877e263aa40093615cd30f9a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cf5fc43971463b5846a36ad8b558af87890f0b149909db8aa897a10be8b232cf"
  end

  depends_on "go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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