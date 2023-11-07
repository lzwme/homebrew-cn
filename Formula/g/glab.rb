class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.35.0/cli-v1.35.0.tar.gz"
  sha256 "7ed31c7a9b425fc15922f83c5dd8634a2758262a4f25f92583378655fcad6303"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2607332763019f08130aaa9a37562e11b6c3e38d09ca3a18ff5d9649b8b37df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97be04ef0f4f6f19e3116c3d73396d7a08f07b7efd105675effe2edd04736b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2cceef163d531369fdfaa0779a15e1fefb3b4936ce96bab2f21a323d9c68ae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c28225e98bb5a5558aa1fd1860b0bddc9329d74f94f70740220542ded8183bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "5fea13314960b160db1c786ceb5f531f2236f7559c1d37d6510283ff3a632dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "a8a7ab15807e4bd8903615b357b07c9e3ba43c3ea1f31554de61cd3eddce5e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc403a79ff621c35d0cf618fa93b546d121ed8648502def919f8b8a3ccd410e"
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