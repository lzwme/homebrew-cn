class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.99.0.tar.gz"
  sha256 "65fff9aa7eb4410689c4c4c6756d2ef58492b1a6ce985e97dfd1b61588aa52f9"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5224939a9ac06730bed569179064f5cfd180f47e4936d69c9372b08c74da8f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f30b21c1fbbdcb5b646c7f168936fb66cb554066d643843e38e11c257c3486f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8010a0176d2bf6af28487cf7679dadb9055700423e4eb93cf71866e3134407f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe152a5a4c6b091cb6f79d018d5bef4cb7469165f092df94c1d5e042308f791"
    sha256 cellar: :any,                 x86_64_linux:  "902ef507d77cd3697563e9f1b289cd6aec222150b43dc8a53da5fad4aaaa8963"
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