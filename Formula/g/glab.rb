class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.103.0",
    revision: "c724bea5fca299c989b0b27b2b24cd1cbe7136af"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "536211ae0f9658da51109aceff164487bc851d4f7300db950b118b964c92bb78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "536211ae0f9658da51109aceff164487bc851d4f7300db950b118b964c92bb78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "536211ae0f9658da51109aceff164487bc851d4f7300db950b118b964c92bb78"
    sha256 cellar: :any_skip_relocation, sonoma:        "e330fe12ebfcf18c6ab6c42d46102491a5766b423699e2956558d8221e028c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7f57639610d565b05f4a01e15a4c6709a3e8a970da841987fab7c8ae009eafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d82f2477271ae27c2adcb0e5df1403f50b9c77513013ca1ace93411da2424a6"
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