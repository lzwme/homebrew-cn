class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.29.3/cli-v1.29.3.tar.gz"
  sha256 "4acb68e831948ffa8c31bc777a3100f2459c6360edaab65e1720805dbc04b8b5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f3f6e3b57988ec8ff2b8b86cee6bbd6134a7a50ce42ab35b97990619c1054f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f3f6e3b57988ec8ff2b8b86cee6bbd6134a7a50ce42ab35b97990619c1054f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1f3f6e3b57988ec8ff2b8b86cee6bbd6134a7a50ce42ab35b97990619c1054f"
    sha256 cellar: :any_skip_relocation, ventura:        "b2b988ec9fdc0a4b1bfc3815486ed729ab2e917b8d0a16a81a197cdf207a20fd"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b988ec9fdc0a4b1bfc3815486ed729ab2e917b8d0a16a81a197cdf207a20fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2b988ec9fdc0a4b1bfc3815486ed729ab2e917b8d0a16a81a197cdf207a20fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c634f475cf210fe483e4bc3ff2180ab66c9fd3b992eccd6e4e5f64b09f1c1b44"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
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