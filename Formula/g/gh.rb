class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.88.0.tar.gz"
  sha256 "f26b30659630254b9ec19e4a8f50a3b1315cdacde63e57e7f2c1292758c92c89"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a81f5139d9fe4d8d862534d91c4ad213494efabfa51104733c66817579269dd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d9e31368523c6f85f521ab27add0dec89863fb699bd6fd0cb513e4fb0679bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190842a55723d5ec49f2b3b776b94504a902e89378f60b1bbfcfa2713daeb620"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3afee2e6f3ace5a92072e45f9aafbc61c0f6361ba6984d7e2247267a4badd3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f43db24d933c43331c744b41c7e9e0aecc1b321e9bad279247414fee4c4fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3458635911ed0487ed5a3abec5b8ac409eebc6f1a6347733000e7188333d99b"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end