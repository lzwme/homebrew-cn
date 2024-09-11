class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.46.1/cli-v1.46.1.tar.gz"
  sha256 "935f732ddacc6e54fc83d06351fc25454ac8a58c465c3efa43e066ea226257c2"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ae82c26c2b9216564d7d8d41bfe6af6d913949e45b0dc4c467cb4ed588f1113a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae82c26c2b9216564d7d8d41bfe6af6d913949e45b0dc4c467cb4ed588f1113a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae82c26c2b9216564d7d8d41bfe6af6d913949e45b0dc4c467cb4ed588f1113a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae82c26c2b9216564d7d8d41bfe6af6d913949e45b0dc4c467cb4ed588f1113a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8a036c8eb1f0853f5ef7b4c660b24e9c879f8d0d2bc0367e62126920122f3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "a8a036c8eb1f0853f5ef7b4c660b24e9c879f8d0d2bc0367e62126920122f3a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a8a036c8eb1f0853f5ef7b4c660b24e9c879f8d0d2bc0367e62126920122f3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1c21674a71a5437a24c952887bf744d8b484b0f469456d732832e72d5b23e8"
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