class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.85.3",
    revision: "068e6867c751f4959b26c8788b9bc72980d4d598"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c6b224d3ef101e8a8a4756fbcd4705d5d1684c8e2d315a8f6d9d44031bca639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6b224d3ef101e8a8a4756fbcd4705d5d1684c8e2d315a8f6d9d44031bca639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c6b224d3ef101e8a8a4756fbcd4705d5d1684c8e2d315a8f6d9d44031bca639"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac18ead936351cde9b3139ae7393498be784e099c1889a458bca5d768c87ef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a71934b837f2c8611653b05314f8ff3db629860982468f84ef1b6dc6d9b5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14bc6b4989a4c2e677876355b587e2b15e0459d9e8064c2cfd226e571050887"
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