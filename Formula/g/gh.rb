class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.90.0.tar.gz"
  sha256 "87a6a3b3df1155e9d253ec6ae273d9e018773498b7ce7570f896a7cb75b64e39"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086bd33723b973dc61c01c99a4e06241df85f63722335a5637ce089cd078e31e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "143e68329fc9614d11836256f7a42c4c79591305bc5aae03e8299b51f7ea4a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef38583af8c0d4b75779e6ccba98d96c371b81d4a93b35ab76c4fdacd6c99f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95c2901e04c5ece0d95dd1eb4aca6e46f65116eb38163e67be55680b2dfd6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe2afefe0ec4adea2743ed64a0ffd8bf73d3cd6783a150b13321c98235df8f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40922c9ccacd7093c9dadff417bc46706f271e31d1511bced8e36c1e3d53e8b"
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