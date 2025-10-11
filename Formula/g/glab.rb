class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.73.1",
    revision: "1acdbc29ecb3d56239636db8b76f9cabfdfcee7d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43fac95d7228e0b74991248c37349482e4160e9f5d12e8b9966cd8a2e0ae19c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fac95d7228e0b74991248c37349482e4160e9f5d12e8b9966cd8a2e0ae19c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43fac95d7228e0b74991248c37349482e4160e9f5d12e8b9966cd8a2e0ae19c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f46e06f1b78bc82d8ab4f38e99c61ef04189f50833598cebe29671df6e09732d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba159282d023fc6f0404797e52106ac7d63eba8ba75f506ef5a7ca9c75e2b779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b9c1244e9e297d8aa20cb5fa619e27351aecc8313ffabc175a89f0f96b8346"
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