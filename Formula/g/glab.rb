class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.53.0/cli-v1.53.0.tar.gz"
  sha256 "2930aa5dd76030cc6edcc33483bb49dd6a328eb531d0685733ca7be7b906e915"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9a4698da8f10168e649efb68117db4ed7663eded0f813b0a2c7bef4bbc233d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9a4698da8f10168e649efb68117db4ed7663eded0f813b0a2c7bef4bbc233d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de9a4698da8f10168e649efb68117db4ed7663eded0f813b0a2c7bef4bbc233d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e2e749788e5ac0ea632ccf5224b125170a54aa5153be6bafd6e48d3ffd38d88"
    sha256 cellar: :any_skip_relocation, ventura:       "0e2e749788e5ac0ea632ccf5224b125170a54aa5153be6bafd6e48d3ffd38d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b47b72c3a59fd7d975f05d2be6c62c69d61940f679197657f6c28d29f10851d9"
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