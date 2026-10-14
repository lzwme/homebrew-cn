class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.123.0",
    revision: "5686d7484e65cb08b6e3b92f86d2ccffb415bdc0"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "938898e31c084f6729c926a0923e8321701356e1aa775db01300a029ac1d9f17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "938898e31c084f6729c926a0923e8321701356e1aa775db01300a029ac1d9f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "938898e31c084f6729c926a0923e8321701356e1aa775db01300a029ac1d9f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eceaf6dffda742b500f50c4f267dd8c3edeb45f5675c0aba67cff9396331b0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "afcb0db3d846dd68a0955e4bd36fb2f36311289d77d14fe49fe20bf113590f13"
  end

  depends_on "go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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