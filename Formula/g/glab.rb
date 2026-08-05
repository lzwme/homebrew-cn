class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.112.0",
    revision: "816e3a52411aba73d90237859fdc6ecbc86bd169"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b985f101f55a0dfc8b992da1861a65c05006e759cf0a764d8f907604ac5ed09e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b985f101f55a0dfc8b992da1861a65c05006e759cf0a764d8f907604ac5ed09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b985f101f55a0dfc8b992da1861a65c05006e759cf0a764d8f907604ac5ed09e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f42ec7dc5e937066b84d6632012fa0b0c3cc4b7b5288f784adb14e60eb2f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a9a077c83dc4c8ccb1a5d08a66ab6ffa92c7bdf4bfc772255806bbdac37931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d58c19aa787f06f08e310e8cd5a285eea12cc0fde9d87c5feae18e534b9f3cc"
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