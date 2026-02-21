class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.87.2.tar.gz"
  sha256 "b36313ba276842bcdc59d40d2f3497fe373fa19ec0d54bde72594134631cd538"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b3d633d83ef4521236e78593c80c69e2a4760f7cdbf265e477b7eda2bf9822b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7cde50afee611e7781566884e112102ee4015e0cd4f1f86da8b65f579aba83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84983acde47257e3b8680792555f2aed3207dcc6a0164bcc9fc22b834d55ff74"
    sha256 cellar: :any_skip_relocation, sonoma:        "01ea8cb8b3dde3ad4b98eddd4067d42ad8b94135657aa20c65f7c795e726ed39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e099834e0662fe1858049f99ca39b0e4637331c95b036fb6ec34ba4c6fe720a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34294a1221ce3660ce18c27cf8684f085cff0442a8f4798a024b87195b80b39"
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