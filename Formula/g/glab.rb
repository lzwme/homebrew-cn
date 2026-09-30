class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.120.0",
    revision: "78790114c4d7196c97b2b1a1263a0d725835640d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12ba3ab3bc1c5609ec634ded580e0df39f963530a51274e1e6c60e0287b2fbea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12ba3ab3bc1c5609ec634ded580e0df39f963530a51274e1e6c60e0287b2fbea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12ba3ab3bc1c5609ec634ded580e0df39f963530a51274e1e6c60e0287b2fbea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd47a7179935d6fcce62c3b871577fe37230d036c3eb1f4ab8d815977e213ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d8005ffcc77b64dff01001bedb4c2cce0d04c880a531e3559d4d7289a3f7d41e"
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