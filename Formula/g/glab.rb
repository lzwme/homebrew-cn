class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.74.0",
    revision: "0c3139375a9c4f011ab19bee37418f9aee626cef"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2553c6ecad79b0651f9f5c06b973b0056aa67efc2665275623afa60ad7184f8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2553c6ecad79b0651f9f5c06b973b0056aa67efc2665275623afa60ad7184f8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2553c6ecad79b0651f9f5c06b973b0056aa67efc2665275623afa60ad7184f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0b28c8622e58eaf61209707d9d71f92589d5aed2f3ed60eef66e94d43d73ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915b070c7bcdf56a270e681d586db2072ebd17cb1d372057075886bc178bd85f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d2301a5e5f80842bbc302996c1c6eb6679b0c8387e8897260084a3b3b96ffa"
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