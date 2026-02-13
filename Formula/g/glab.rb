class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.84.0",
    revision: "9c02d4257e00198e9c49668fe85ac2915db50053"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08d2585d575473774dc7d9ec8443ff9ab08346f6992897473c0619311914735a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d2585d575473774dc7d9ec8443ff9ab08346f6992897473c0619311914735a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d2585d575473774dc7d9ec8443ff9ab08346f6992897473c0619311914735a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a74982fe043365d48980f588180eeff17df19cdd60e0b0f685d03838a13df12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69731e37f154538508b3a50b8be86f7b37a932d3b702ea251b79c0232dcc4840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da91e78ba1346797add101824802b1eefca8a9d86924e4f6cc044d0dd89a3698"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
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