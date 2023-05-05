class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.29.0/cli-v1.29.0.tar.gz"
  sha256 "5ea8c805f3555352c2cc55cf174f1430dffe3a19570ce25b1889a3903fd0dd0f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a41cee77c0402df40b5e4a6d269b8955e85731ed47a655b97d087931ba7598"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a41cee77c0402df40b5e4a6d269b8955e85731ed47a655b97d087931ba7598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a41cee77c0402df40b5e4a6d269b8955e85731ed47a655b97d087931ba7598"
    sha256 cellar: :any_skip_relocation, ventura:        "49e6e250a6a2ea43e9e62bee5efc3566b6e3cc6cd53f98bfbdc1ffc647bdaab6"
    sha256 cellar: :any_skip_relocation, monterey:       "49e6e250a6a2ea43e9e62bee5efc3566b6e3cc6cd53f98bfbdc1ffc647bdaab6"
    sha256 cellar: :any_skip_relocation, big_sur:        "49e6e250a6a2ea43e9e62bee5efc3566b6e3cc6cd53f98bfbdc1ffc647bdaab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d3947022955207d22789a174d90415d63c1d1ff74392b91102c56ee714d021"
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