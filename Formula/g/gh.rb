class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.60.0.tar.gz"
  sha256 "1936a80a668caef437b2f409eaa10e48613a3502db7da9eea011b163769218a7"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a8c043d0ecd2c29a0fa1b9fa9d1216c089a2234bf58e14d4e43b4f96c914e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a8c043d0ecd2c29a0fa1b9fa9d1216c089a2234bf58e14d4e43b4f96c914e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a8c043d0ecd2c29a0fa1b9fa9d1216c089a2234bf58e14d4e43b4f96c914e87"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f72a7caafafacd449fdac022431a2170a5a5c87481740d8bb2b32dbd4548af"
    sha256 cellar: :any_skip_relocation, ventura:       "d09dd68d81d7679d10f81873f9aca0aef88e6041da36482b0a69ba57c66ab31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7f4b3d49b58a62216fff141245c6086a19e2bf9cafc776cb20557842548bcf"
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