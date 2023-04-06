class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.27.1/cli-v1.27.1.tar.gz"
  sha256 "c2959152b51c39097607f13d64bcecc04121ab7c52590505ebaa0693c6058507"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e050f01dfe4d9284eeaa20269a422b0225bbe71e5a4fecbd4d6fc4d0e76bc10b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e050f01dfe4d9284eeaa20269a422b0225bbe71e5a4fecbd4d6fc4d0e76bc10b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e050f01dfe4d9284eeaa20269a422b0225bbe71e5a4fecbd4d6fc4d0e76bc10b"
    sha256 cellar: :any_skip_relocation, ventura:        "023403f7807f375e526f11f4e40dc29d343a6498d12ead70d165575ec7ed7981"
    sha256 cellar: :any_skip_relocation, monterey:       "023403f7807f375e526f11f4e40dc29d343a6498d12ead70d165575ec7ed7981"
    sha256 cellar: :any_skip_relocation, big_sur:        "023403f7807f375e526f11f4e40dc29d343a6498d12ead70d165575ec7ed7981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eefe6ec059faa193c6a9600ab84c5fe3fb6f8e0488957bc7adcbcbe9ebf5e4fb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
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