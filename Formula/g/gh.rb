class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.103.2.tar.gz"
  sha256 "73a62f89937b2c058e0873a571f4963a28c7c78d3b60d0bf29e5658789eb8012"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e81d54cc135cfa870bee43d7b2dad8f4f41c8e0a4ee78c6e7bd3b0ff32f567f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "377221113c1225f2a2bde49029a0ac80db57aad02b97fa8b3e942ddf901bbcca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1425c7f29cf9d3885896e094c101d3100632fbd0315d8d3e9b9a38ac79d3ef25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3229d5178681084bdc8bbc27e8a7dbea176867b9641eaca1bcf9cd63e8009c4"
    sha256 cellar: :any,                 x86_64_linux:      "1250e1d64b7927e62c64fd225dc72c3e1dc5c980355d6eb0f25eb5c9623b7439"
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