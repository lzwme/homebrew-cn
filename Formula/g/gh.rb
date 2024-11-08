class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.61.0.tar.gz"
  sha256 "bf134281db2b65827426e3ad186de55cb04d0f92051ca2e6bd8a7d47aabe5b18"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f81e1082f914c7c130ab7422b345c9dadbafb3bd4abd91be8a9e38699cf282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f81e1082f914c7c130ab7422b345c9dadbafb3bd4abd91be8a9e38699cf282"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3f81e1082f914c7c130ab7422b345c9dadbafb3bd4abd91be8a9e38699cf282"
    sha256 cellar: :any_skip_relocation, sonoma:        "f83daa15c177336aac63b94a82ce61279941ffb1d916aa887d3233343b1549ac"
    sha256 cellar: :any_skip_relocation, ventura:       "9fabea9f16849f8daeeba81d5b0a8813bc08b3f11d65c895b2483be34eedac58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a5fd63f656f46e2cb178651b717bab534838175046da5b1533ce80d9500567f"
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