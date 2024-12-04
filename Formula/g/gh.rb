class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.63.1.tar.gz"
  sha256 "b9a90118dfb46204dbcc0d09c2073d48f35b6f640b4db33fbaa24892fed56c8d"
  license "MIT"
  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b9e66518a37d402ef948676d2ed68f16d318c57ca70b6368014aca0ba763661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9e66518a37d402ef948676d2ed68f16d318c57ca70b6368014aca0ba763661"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b9e66518a37d402ef948676d2ed68f16d318c57ca70b6368014aca0ba763661"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed02d2a090952ba23e581c52aa69288ac6ad9d19d1ce911a9e7ecbc7946197cb"
    sha256 cellar: :any_skip_relocation, ventura:       "d2c832461c946f411f1576defa3bd09ac90d75399adc59dcda825a5a1dbae08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c25d1d5f0e5e7a02c0baf303b38b14e86c20672c4507c3102abc20f94fa86cd0"
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