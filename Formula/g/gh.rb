class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.103.0.tar.gz"
  sha256 "c15a3794f56f6b9c0dca05d5f5b357f27da3c1b7031523fb42c0870ef16c6aff"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f7bf9daf6c960e72a6afb54f6d6d03c563aa9f484b679bea855e90f7e9fc8af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f1a6f07e07b116773cd998d4ae9f7bfef47df25fc649a73b8f043e3290c01d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ca0987497c217db42ebe41847469b545e1b8a499ace3a8760180ffd38936f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ccc9166e4cb98e308c402435ca92727a5e43fecdc4683a1eca67e24821aa0d3c"
    sha256 cellar: :any,                 x86_64_linux:      "9fbc9834515b57e17ebedd507d2482630f739836d4912d3d3eaace1ee357622c"
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
    ENV.prepend_path "PATH", buildpath/"bin"

    with_env(
      "GH_VERSION"   => gh_version,
      "GOBIN"        => buildpath/"bin",
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "licenses"
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
    assert_match "GitHub CLI third-party dependencies", shell_output("#{bin}/gh licenses")
  end
end