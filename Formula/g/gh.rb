class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.71.0.tar.gz"
  sha256 "2c90daff813e921e60b1a5633d1c981f51ef667a81b2193a41c50546b8ba6bfb"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9001768608a90a9aa33978077013bdb12b694f02c59932b3f7874672a5cd7c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9001768608a90a9aa33978077013bdb12b694f02c59932b3f7874672a5cd7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9001768608a90a9aa33978077013bdb12b694f02c59932b3f7874672a5cd7c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3fb0ce46b7d66accc0cd76ab7b812446450338592dab92b13cbfb920a41d479"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea80d0059885a4bc608d02fed1417d3d75039c9dc8304dc4e5b73fd21b5bb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558173e7d34991025e0b1a8671d306ccffc0e873ff867df689dbd5e9ae85d67c"
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