class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.101.0",
    revision: "b37860458a2c5f0ef8caf606ae5b8be30b0c62b5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "503441802b8b6b54bae5165370b19a9d059c861a8ee99d6e32780137b8eb664d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "503441802b8b6b54bae5165370b19a9d059c861a8ee99d6e32780137b8eb664d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "503441802b8b6b54bae5165370b19a9d059c861a8ee99d6e32780137b8eb664d"
    sha256 cellar: :any_skip_relocation, sonoma:        "934d2441b952461aca51f0063130e85af6cfda2f4fa451b736c3fdddd9f46d6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4593db4249261e7371438fd267835760293ff95307793d632cd1e16a39d23cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36451e58334031a6e43fdb4102a320fd690d4f6a415f9d38695f05137d9a00e5"
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