class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.68.0.tar.gz"
  sha256 "9c211ff501fd42e1a842b9709cd994a59d39b6d34014d354f00049240b8d8838"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d28c058a79afae03b4fffc1f90a563c6973256b50b2e66926077b48874c98fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d28c058a79afae03b4fffc1f90a563c6973256b50b2e66926077b48874c98fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d28c058a79afae03b4fffc1f90a563c6973256b50b2e66926077b48874c98fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6703a5d73148dcf92abf76dc6e3d8f5de4f79f93cb90a69b679becc40a83ccb1"
    sha256 cellar: :any_skip_relocation, ventura:       "38291cc7ae3d417810d442940cbdf23623234c07abb71c65eaf6cc054d5131b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b60bdd960bdde3e5ec77f2caade160106ad55dc50f30b41d633338c51cb503d"
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