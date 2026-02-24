class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.87.3.tar.gz"
  sha256 "8aa3458df7204c8b788e3d05c1363fefd899f8a53de22b067d924f24a8ae75ea"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f465a7d428d901fa3ab096e63cd1478807f7fff1ffa616e1a54c46ec594f4abd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b26d8a5351b8953334b33906d731168bcb7a0364095285c8bde86865e7e63776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b214f358d87f3003cf1bb74e071a27f5df24f02451640b431d2f4935c7d7f460"
    sha256 cellar: :any_skip_relocation, sonoma:        "46a96667e23656328f7289b0e8548bfbd5a934226a953575d37beddcb7c60026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a4b0c9171b46c98392144a49ae8142e9199f20f5875d1751bd0fef6a3a8d4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "586b9d38ed7e7077f2cccf16cdff5864973ee211edf65c03a1815262c63900c8"
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