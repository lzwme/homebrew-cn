class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.67.0",
    revision: "1e957280ef088dff263bcf1ed7e22f9e8aca469a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc0da6dc82382663d920b3e4fc05ca6c147457c4b00a0b511ca21500de46160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bc0da6dc82382663d920b3e4fc05ca6c147457c4b00a0b511ca21500de46160"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bc0da6dc82382663d920b3e4fc05ca6c147457c4b00a0b511ca21500de46160"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47cd243899c366ffa694e2e36805f597c52e7b95402cb1fdc2abd6592127ae5"
    sha256 cellar: :any_skip_relocation, ventura:       "b47cd243899c366ffa694e2e36805f597c52e7b95402cb1fdc2abd6592127ae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2897831ec770ef5f4cb3243298aa798eb0782aa068a51f6031825197d7b7a265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6467fad7688d1f683b70421bda3055c0f702d82ba5857366c889bea076bd07"
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