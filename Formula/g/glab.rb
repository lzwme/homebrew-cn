class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.115.0",
    revision: "c3612c8deb89183da68aa0d31ca1f748f381d820"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31248cf579e7a46f7b36681091f0830ff8e28d6e1fa5bf540c3c687660589949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31248cf579e7a46f7b36681091f0830ff8e28d6e1fa5bf540c3c687660589949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31248cf579e7a46f7b36681091f0830ff8e28d6e1fa5bf540c3c687660589949"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaea3371059ff5d609ea2e0eebce79e6126d7ffcc452f6f9048ce51585efc080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1638de6b27896a3245a20ede09ac7a5827a279d09bd86444c76c0160a9d3902d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0314340b64e3c6ad2a632a546dd52bbb9aaa4b46e7c9c459f947596b73e7d5"
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