class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.75.1.tar.gz"
  sha256 "b25543af676ab86ed0715fd322f3644b92de68aff45f36463eca710ac81a85f4"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3021fa79683fa4188f01aa61ede509aeea043c5956089c9ebfa40c126c4014b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3021fa79683fa4188f01aa61ede509aeea043c5956089c9ebfa40c126c4014b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3021fa79683fa4188f01aa61ede509aeea043c5956089c9ebfa40c126c4014b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4755d3687abe6cf54c47205a9e8252b441ce2b6c0a4fc6020afa04350091c426"
    sha256 cellar: :any_skip_relocation, ventura:       "47a03e6f4f6339943cc25319a16081329f5579989e0238d489ecaa031f058039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68b667da2a9a63d35da8d1ba87509e57270475bf4c9be2b5f05fd67bc310f3c"
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
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => "-s -w",
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end