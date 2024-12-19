class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.51.0/cli-v1.51.0.tar.gz"
  sha256 "6a95d827004fee258aacb49a427875e3b505b063cc578933d965cd56481f5a19"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77052b1b76bcd24a6b8f7ff61f9912ba53cb12abd39542d8c3c809301c817c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77052b1b76bcd24a6b8f7ff61f9912ba53cb12abd39542d8c3c809301c817c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c77052b1b76bcd24a6b8f7ff61f9912ba53cb12abd39542d8c3c809301c817c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f88c6929ab0e6c89fe0befacea70ac68cb7e07fd8316829803564139ad144868"
    sha256 cellar: :any_skip_relocation, ventura:       "f88c6929ab0e6c89fe0befacea70ac68cb7e07fd8316829803564139ad144868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9fbb1fe672e1712a7fe756aa4bcd48696495d8188ee31919f0bb469b7d3639"
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