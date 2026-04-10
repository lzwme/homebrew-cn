class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.92.0",
    revision: "c182e188657b79e08dbabbe0c97f3e7b554ea97f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fc258fd8ed624cb0c202ef3be59c0287945edef94af09884f9598e691d669c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc258fd8ed624cb0c202ef3be59c0287945edef94af09884f9598e691d669c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc258fd8ed624cb0c202ef3be59c0287945edef94af09884f9598e691d669c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "56738dc55f77c225d87b567e86dbe4a17bc59798395eedb925ebdf0e54470046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42a30d83f214146876827ddf313ee08c8387004c590418652401b103b5c51e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82a74318eb90e4e281fb01832441edc0634df38dfd52eec90317c07df82cbff"
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