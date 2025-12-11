class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.83.2.tar.gz"
  sha256 "c031ca887d3aaccb40402a224d901c366852f394f6b2b60d1158f20569e33c89"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b2e5af43deeb05946308605a6696110bd70c231f2407593794c64ad37a1e78b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2e5af43deeb05946308605a6696110bd70c231f2407593794c64ad37a1e78b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2e5af43deeb05946308605a6696110bd70c231f2407593794c64ad37a1e78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "75a0d198b8e8faf1bd6a82777ccbd05ba091296fccb9d3c34155d021767841cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e5e982468b5d4e6381a512928348fbdd3a3dc05d1cd0d9a1592b8862a5de54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9911518b3e82e5a14d9b0ecd5b23fa7f7d47c61ebcaa46b6bd18240348168c3f"
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