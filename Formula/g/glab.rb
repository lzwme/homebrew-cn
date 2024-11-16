class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.49.0/cli-v1.49.0.tar.gz"
  sha256 "8ad87c6c5157a946512f1225e6ab71adcff3e1606f0e0341ecadb037716376f9"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f50e912f6d7503d845e00d3707b3cc1fb6fbf395ec206bec594600b5f8d5edd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50e912f6d7503d845e00d3707b3cc1fb6fbf395ec206bec594600b5f8d5edd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f50e912f6d7503d845e00d3707b3cc1fb6fbf395ec206bec594600b5f8d5edd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0909a97722486258ae97f192d509b2861d818014749ea97e87118db06125d038"
    sha256 cellar: :any_skip_relocation, ventura:       "0909a97722486258ae97f192d509b2861d818014749ea97e87118db06125d038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef0b894bac98eca5f44e1d7304366ee3327840ad54b4c57f94be37bbcac17d0"
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