class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.27.0/cli-v1.27.0.tar.gz"
  sha256 "26bf5fe24eeaeb0f861c89b31129498f029441ae11cc9958e14ad96ec1356d51"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee91190d5633e3e2d70b32b998988e19e5fcb5131ccb04a71edd18f715508069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee91190d5633e3e2d70b32b998988e19e5fcb5131ccb04a71edd18f715508069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee91190d5633e3e2d70b32b998988e19e5fcb5131ccb04a71edd18f715508069"
    sha256 cellar: :any_skip_relocation, ventura:        "8bc9b7430f22619bdf1b153d6644ebca2e27dc53f184a75ca133e297654a8d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "8bc9b7430f22619bdf1b153d6644ebca2e27dc53f184a75ca133e297654a8d3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bc9b7430f22619bdf1b153d6644ebca2e27dc53f184a75ca133e297654a8d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22708db04a3598894035f727fee5878c026a4a16c8ef45e1c715f6030ad1c759"
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