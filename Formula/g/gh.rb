class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.82.0.tar.gz"
  sha256 "c282c0bf2a2c694c99dd7d6da1ac13b3e87c1a511186ec66f0144d8b0ac94a49"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "759385e25d67e744ad0692bd575f76a99410f0f5e9392d80caa3eb795a404167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759385e25d67e744ad0692bd575f76a99410f0f5e9392d80caa3eb795a404167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759385e25d67e744ad0692bd575f76a99410f0f5e9392d80caa3eb795a404167"
    sha256 cellar: :any_skip_relocation, sonoma:        "87b4201378d596b3c4b66068c61803edc468eb0f630a18b3a69c5104c2cb1353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0a5fa3c8ed249834de1219821a929f7904cc4244ca0418c5fb7cfca43b2b97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f427e168a92aa08ac884da4b6130f355f72674e7b768d6e9f0bdc3e9d9fad6ac"
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