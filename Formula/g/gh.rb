class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.64.0.tar.gz"
  sha256 "229fd8fc51325ebb5a357af6af116094d6be6a5f1e0f0923b7892ed01b208abb"
  license "MIT"
  revision 1
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3486152dd9a8de49018b2852d61d8514c51b48e22bee427c2d68f6499452178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3486152dd9a8de49018b2852d61d8514c51b48e22bee427c2d68f6499452178"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3486152dd9a8de49018b2852d61d8514c51b48e22bee427c2d68f6499452178"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ce12a9132360b14d7fbb683c97a1ff7b4a356df7b8a62dc8185500e4bd4c91"
    sha256 cellar: :any_skip_relocation, ventura:       "95ed659503204d7e2016ec5baee6943cc013385edfd2fcf3cc719866add4a5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8489384447e7f99db786dc20f15e106a8095f564a608456550f8213af006ff8"
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