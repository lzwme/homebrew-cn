class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.34.0/cli-v1.34.0.tar.gz"
  sha256 "278d68f57704e481e0653306ed47c3d29a506d56fd6e4a6351d167c400a5e119"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "461588759459e4042c70349d415590f5ce0707d6438cb0f79f492ad42eb90622"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f48d6ae405e11bbed59fba0fcc93604b854bb0280d37e1b3c0b1ed00eaccc4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b232f9491cc80bd0b53ae6ff490e263b4c0e62056d3798b04838dfe4ce681241"
    sha256 cellar: :any_skip_relocation, sonoma:         "845ec959647f2b2352862857ff24a08a7160fe93fdc3e05015bb49bf5f0bcb7e"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd13fe883e28fca27bb7c874ab62397d31606ac0a67cd96ddee1de2d3b9c0af"
    sha256 cellar: :any_skip_relocation, monterey:       "8c74c5634b83863383d77ea7e3e794ddb62efb229cb2d5a16f1f41dcfc45b334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80af55c4527c2facd21a193f4961ee11052d1c4abc87b707878fc0c7c621cf62"
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