class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.71.2",
    revision: "850bdd79284e7a2fd613c99341fef2c36dc64679"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4be439f0ac8851dbb114e16bf69ff3c545f400b7e6ed3010a4a0570d1fad13ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be439f0ac8851dbb114e16bf69ff3c545f400b7e6ed3010a4a0570d1fad13ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be439f0ac8851dbb114e16bf69ff3c545f400b7e6ed3010a4a0570d1fad13ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e10e0006a6b4c46d55323b4868b6504128e9a613d2cc27237fa454709836348a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c9337650ec8c9da5a520f4453ae77edfd0623e6dcd268c699d1a92de903ce39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d1a9e71975b70d751fe201fc6c9b6d8e6aa6986b89489d5801e27daaaf467e"
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