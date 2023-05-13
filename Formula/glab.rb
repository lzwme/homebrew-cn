class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.29.4/cli-v1.29.4.tar.gz"
  sha256 "f6c628d376ea2db9872b1df20abc886281ba58b7bdf29f19dc179c541958640b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80cd863b9a9dc07795df721dd3a6a04d4b24c943369d0fc7922c5dcae56dfe64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80cd863b9a9dc07795df721dd3a6a04d4b24c943369d0fc7922c5dcae56dfe64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80cd863b9a9dc07795df721dd3a6a04d4b24c943369d0fc7922c5dcae56dfe64"
    sha256 cellar: :any_skip_relocation, ventura:        "24d0ef227e2900d2df4aad8e4d935250b3acaacbeefb90bf25e3ecda1135b16a"
    sha256 cellar: :any_skip_relocation, monterey:       "24d0ef227e2900d2df4aad8e4d935250b3acaacbeefb90bf25e3ecda1135b16a"
    sha256 cellar: :any_skip_relocation, big_sur:        "24d0ef227e2900d2df4aad8e4d935250b3acaacbeefb90bf25e3ecda1135b16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3db7509acc91a297411dcfc507652be57353fab47fcd88f2061d385e374deb3"
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