class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.60.2",
    revision: "001b8c4d5b83a7f96fd8dd4280a8f0d5eba5a3b9"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9623bcd1676199d3b43ef2ffebd67cc4ff5ade9a0f90038bb5b148b09823a0fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9623bcd1676199d3b43ef2ffebd67cc4ff5ade9a0f90038bb5b148b09823a0fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9623bcd1676199d3b43ef2ffebd67cc4ff5ade9a0f90038bb5b148b09823a0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "21592419029ff4dca6dadef176c60c8648ad3d0c51d0df3316e944259ab27b71"
    sha256 cellar: :any_skip_relocation, ventura:       "21592419029ff4dca6dadef176c60c8648ad3d0c51d0df3316e944259ab27b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595623efa6d052cafba32b50548916515e7d09604fc8376162033cc4b717d871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe5b8cd4ebd1ac4a8975b1bc3c895e0925977f0448be82106b9c5de3e9192e2"
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