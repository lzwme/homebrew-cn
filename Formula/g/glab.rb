class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.87.0",
    revision: "7e37c75a051e6b8619e30a32cca0a51311045dd7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f68d25789e2dea65f6d999438112620e69556d24ceaf9366ad2348da365af679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f68d25789e2dea65f6d999438112620e69556d24ceaf9366ad2348da365af679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f68d25789e2dea65f6d999438112620e69556d24ceaf9366ad2348da365af679"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c937905bab023d00c9f39e18c3aa5cd354edb0ed7d344def6266cf7f879808f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2a89582ba3e982ef66a9dafc074dd85345bb19cfe2d6546d6372800df368018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f7f0a4e66519bdf85d6704ab2c7ff92fff902a5d8d7f2c6584d8be06a8d7f3"
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