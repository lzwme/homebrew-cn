class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.80.2",
    revision: "cca0f120be46f464b84f88b9ce69007314499a2a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f4b471c634a5b48360bc6cf631ad1317b375c76c2d8e592d63d0dbc1038e427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4b471c634a5b48360bc6cf631ad1317b375c76c2d8e592d63d0dbc1038e427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4b471c634a5b48360bc6cf631ad1317b375c76c2d8e592d63d0dbc1038e427"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa71a5259501cdd6df1d45530b767a2cc06095988f60eb44b48134b70659bed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aba0955b51b7651d19c58e641c34c2135ac0d8069f7ea3abb5d601a838027cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5837f2873abca2e13c67b3c537654d00c4f59ada1827f54ca0e16e48522d390c"
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