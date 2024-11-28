class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.63.0.tar.gz"
  sha256 "c5309db9707c9e64ebe264e1e2d0f893ecead9056d680b39a565aaa5513d2947"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6e6306d7f696508d90da5a65c4814dc3b8a1bd036e1bc38071fe6654d8f04e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e6306d7f696508d90da5a65c4814dc3b8a1bd036e1bc38071fe6654d8f04e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6e6306d7f696508d90da5a65c4814dc3b8a1bd036e1bc38071fe6654d8f04e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "379760afcab70d2e482cd03f5c13147c020fa53d99ac2cad33fdb8c6840be22c"
    sha256 cellar: :any_skip_relocation, ventura:       "ff57833057b5c6402915bb9d671a6265afa313fd2b2a6bd8cceec3192db9a276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4856c88030e6c70e281ff6482d6ed1d7108cc83434d711c105376e998e57c5c"
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