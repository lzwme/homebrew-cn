class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.62.0.tar.gz"
  sha256 "8b0d44a7fccd0c768d5ef7c3fbd274851b5752084e47761f146852de6539193e"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239c26cefbc6c61ba5918191ec8aca05aaf9ed6d2198dccd4cbcebe3b4980d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239c26cefbc6c61ba5918191ec8aca05aaf9ed6d2198dccd4cbcebe3b4980d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "239c26cefbc6c61ba5918191ec8aca05aaf9ed6d2198dccd4cbcebe3b4980d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "676a08da17ba64c45cc11d35b5863e5474a49e16c8b6453c888fac452547e702"
    sha256 cellar: :any_skip_relocation, ventura:       "96c31aad56ac72fd575ce1bca85e9d23c501eec5e8152057e7094f2092f84838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03f5d23d1a203ad698164969dc5c22d48096db832531e217ace54bf939b940a"
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