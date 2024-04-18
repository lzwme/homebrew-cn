class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.48.0.tar.gz"
  sha256 "a9c40e895293f50c10bfaa0bf92a9685128bd80dd6b4d04c7fea1d5494314a60"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36651fce0f1cd1987bf38360a77bb6ca04f3a78b8ae535f513f818bd9e2f0f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1af1e52f41247e94392569aa2dec21ec0ae546d62d73cdc04214f5871750f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23646cad57e74de84d991df934b4ea90db50bbc93c64067e9bb1a16f40fd41ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "df49bf2323b84af9fc883ee15d02ed3f7cbb263b4c47924f71852dee6fa208f6"
    sha256 cellar: :any_skip_relocation, ventura:        "89e7181965e694e3a631e2a3894ee509d278fb2228154c701ccbeeebed250f0a"
    sha256 cellar: :any_skip_relocation, monterey:       "31b78114a7b986177e4c8646125f5e694cd7395e9c72ed5fdae2bc5f234d4035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cdb32b8b024f42d33a536f23680c028800215cd0b79b15eb854b9cc811570e1"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
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