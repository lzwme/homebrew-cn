class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.102.0.tar.gz"
  sha256 "08bf0ef8b4409893889175e0f5279d30d6edd96465816042c0d7c72eac598158"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "318851adb276a1dea4bd8946a992238627f67af6452c76fac7b86a6484401ca9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2ca0cdf515e105bfc29ed033e0399a7f2cb394350a8846eec13c24025c39ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18e4616fad2b57c7338c590ff74a5c04ea57667a5728e80a39ebd450647db38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c877d6f322155b0060e369ef7e663b451ca070bf645214c8eab5b495496f103"
    sha256 cellar: :any,                 x86_64_linux:      "a2b7a6d6c692202477adcd2dd063af49546bb834f0bae5b002002539d20676e1"
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