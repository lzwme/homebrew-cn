class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.108.0",
    revision: "5de20850a43cbcacf3768f846eee3dae06731ef3"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6702d7a4173b29ae0813aeb1351ca92ed2f16558e9cadd0509d83e221fb8ea8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6702d7a4173b29ae0813aeb1351ca92ed2f16558e9cadd0509d83e221fb8ea8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6702d7a4173b29ae0813aeb1351ca92ed2f16558e9cadd0509d83e221fb8ea8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "25b872acb73136369712d31eb5c551f1c40dcde78e1bd505145268224c3c01af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f35b851fa202cd5703840b9552aa3abde8ac2e2fb96bc55880dcdad8d05c0554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d3c564ed4000c9605a919ffc6037b67f62b81e7e56917a055e96ce34e21f99"
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