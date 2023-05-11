class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.29.2/cli-v1.29.2.tar.gz"
  sha256 "33eea103d4be15e349d56707962e9a1e0adb21454bcf261680de55b063a429e5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6caa328f27e09718873bddfff38184c6fb186e15656f2872644341d7eada429c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6caa328f27e09718873bddfff38184c6fb186e15656f2872644341d7eada429c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6caa328f27e09718873bddfff38184c6fb186e15656f2872644341d7eada429c"
    sha256 cellar: :any_skip_relocation, ventura:        "3fa58030ec3f9f4d37a7da35cbe40e89d89714077f1abf3429c09af16925a8d3"
    sha256 cellar: :any_skip_relocation, monterey:       "3fa58030ec3f9f4d37a7da35cbe40e89d89714077f1abf3429c09af16925a8d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fa58030ec3f9f4d37a7da35cbe40e89d89714077f1abf3429c09af16925a8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca9ba92a319d91735c5f3dbe31b8df050da54f082d638dbb4d4fd97b9f498d0"
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