class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.86.0.tar.gz"
  sha256 "cd2998310e81727af5c2056e9936e6541a20f968d6e3a4891f7fedbc0b336008"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8489bf47b24c28a5f472ed554063331f3d53e89505cb2fa0e190a4ea929815a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4adc3a5daf0704612bafbce5b8c442503a0d26299a531e56261531cb1f5c561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f8743f85faa724745d0617d7945cd9280c2d9339ffca2245b86ee6a2ddaa25"
    sha256 cellar: :any_skip_relocation, sonoma:        "3296bd6598a05001f45a871f59e6ae4291bea840ed8eb9b8c09b21d4733caf5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c88ada5a3688e61967525a4b65342639b3ee2952aac1c6851a1665a5428e455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0790d1e33da9cc93291aa664ed2cb97858cf4a32463a25a260daf94b1ac7ae"
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