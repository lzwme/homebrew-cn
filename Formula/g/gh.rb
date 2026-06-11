class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://ghfast.top/https://github.com/cli/cli/archive/refs/tags/v2.94.0.tar.gz"
  sha256 "cf0b72ca760cc4262d5c7f57fe813dbfe33028e63026c3b6660f9b5e4954d3b7"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd56c626d7ef037b6a86eac4876d59098116e4ffc4dcc9cdd02cf019f6e1da13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456bcb13459eecbb7cff77202c61247df6c9faf1b628164151d7318efd5fbed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2c03c419ecc8f39b76a481ca9b8132902f7f79e842ff7e04734f633fd22f7bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7ca91a74df43e8f62ed4db9e2546a8bd2a0203b4fb8753265a82c5a25af07b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c91749d6290e9ad0bfea97c807a78c0c8787e5d80dc79a2aebf7f70e1314739"
    sha256 cellar: :any,                 x86_64_linux:  "c902335be01c12e92ebd4e54c4b63d9446f34b10c75f4c6b157fc856796375c5"
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