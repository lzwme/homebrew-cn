class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.83.0.tar.gz"
  sha256 "20a734870dc8add2b0df7900aea95521c94125c953def81d3dd705ff079be898"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b90051fe887c8f7aa12f065feacda0c33e23d30483cfcfec1852eae2c38b221d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90051fe887c8f7aa12f065feacda0c33e23d30483cfcfec1852eae2c38b221d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90051fe887c8f7aa12f065feacda0c33e23d30483cfcfec1852eae2c38b221d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ecd7f4a8092db29a7e4cf7f8035abf033778f17d6a69b233d02c6bfbc770386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09687ade353bfc0c0ed771ff23aca3fb1942f970a7c1a3e0d541bfdd398d7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae4e60959ef64deb60c692d14adfe7436dbd3225a340e775e34663cc637cbc3"
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