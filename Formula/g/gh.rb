class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.55.0.tar.gz"
  sha256 "f467cfdaedd372a5c20bb0daad017a0b3f75fa25179f1e4dcdc1d01ed59e62a5"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "848b301ea3e28c03cac9060b1dfe27b25d2949e5311b123598b959bf34b7c049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848b301ea3e28c03cac9060b1dfe27b25d2949e5311b123598b959bf34b7c049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848b301ea3e28c03cac9060b1dfe27b25d2949e5311b123598b959bf34b7c049"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ae5a0881b7a01b6a68e45bee7bc1d89343e29594f7f2e2cb8751075130a2bd2"
    sha256 cellar: :any_skip_relocation, ventura:        "22074fc7d13771f421a4eb3d78198df45cbf17335b3fc083c1480d4e98938ef6"
    sha256 cellar: :any_skip_relocation, monterey:       "6a21dbcf7d8e6e8de7b61a37784d50b92704ade19e5e8972d168319607b52db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9bc648156a1de5fd1faae966c08db5969299ed1819357d9bfb434eb215321a"
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