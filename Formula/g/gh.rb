class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.60.1.tar.gz"
  sha256 "9e9337c2564894c4cd32b2ac419611263c3e870e95567811365aacd4be5dd51d"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7cf1368be9e519dd8d893609cb8f9b4ca8565437e07d824989c85e64c18a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd7cf1368be9e519dd8d893609cb8f9b4ca8565437e07d824989c85e64c18a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd7cf1368be9e519dd8d893609cb8f9b4ca8565437e07d824989c85e64c18a0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b51c355f229929d9a4bf18dfabcd632dd6c4f6cb060299676ef50ad70e5b7d0d"
    sha256 cellar: :any_skip_relocation, ventura:       "327a51ee40e8295402dcea5d10b18d16d97a94a61bd8f70068c4337847984af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52eddc400fbee548617e335c188f3478f50125f63a192425809928e79677fe12"
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
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=clicli",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end