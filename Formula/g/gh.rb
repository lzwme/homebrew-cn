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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b2af35af9cc940a210782b81b3018d8d5fde2b33942d495843344b3b55604b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95b2af35af9cc940a210782b81b3018d8d5fde2b33942d495843344b3b55604b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95b2af35af9cc940a210782b81b3018d8d5fde2b33942d495843344b3b55604b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba053d8cb0fc4949b9fbc902aa88fa6f03ee1893eb046789af4674a47d117d6e"
    sha256 cellar: :any_skip_relocation, ventura:       "b5e81a42cc9c221d3fd398418d21fb42041b506429ff48cd33a6f25ba4a95e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55b43a221219dec027692240422f40adca297252297dea69d26cc3e2e817c20"
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