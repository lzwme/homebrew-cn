class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.73.0.tar.gz"
  sha256 "e432fd7e8944f94624fbd287b3bdd46f6bbed23609178c940bdb7b5d55a6d1c4"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046beaade0306d23d0ee28e7e701ef159d44b26aa324d7b8fc80a1b1df6f8feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046beaade0306d23d0ee28e7e701ef159d44b26aa324d7b8fc80a1b1df6f8feb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "046beaade0306d23d0ee28e7e701ef159d44b26aa324d7b8fc80a1b1df6f8feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9946753c758f993c9b0fb9801fb786bdac09bafda1f75636d92a20235491710c"
    sha256 cellar: :any_skip_relocation, ventura:       "fe5234f1da080ed707089ac8612560a53ac1aba3a6c86011f9df245e87d93b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626c7ba266656072f14a5e64972af3958d07e08b7184c6963f0efaf6409a219c"
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
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => "-s -w",
      "GO_BUILDTAGS" => "updateable",
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