class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.57.0.tar.gz"
  sha256 "6433bca534da722a980126541fe28d278f4b3518a6f7a7ef4a23949a3968e8b9"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a17392cfb2be6f7a0a4631991120fa4445844bde0695d71b49d58ea563d5f8df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a17392cfb2be6f7a0a4631991120fa4445844bde0695d71b49d58ea563d5f8df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17392cfb2be6f7a0a4631991120fa4445844bde0695d71b49d58ea563d5f8df"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35d927c3d530c8024662987d34dde754b76e65b69ce2ab32850ad2acb800b44"
    sha256 cellar: :any_skip_relocation, ventura:       "ee67b4ecaf27b815f29ae80c82388a4fb43254ba2c9ca840795fe05404e04814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc9b576888e05f56fbf74239901ad3b118ce6fe943d99639fefbd3075dda9ee"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=clicli",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end