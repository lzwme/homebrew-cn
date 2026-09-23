class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.12.718.tar.gz"
  sha256 "bad9811684ee9164323c612581774d9163af811f251c6b8367c1b6a442e30ba9"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eadb28640460991e197a8c08f3e78e18bc901b15ac3b17cd05fd293dfa329d94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eadb28640460991e197a8c08f3e78e18bc901b15ac3b17cd05fd293dfa329d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eadb28640460991e197a8c08f3e78e18bc901b15ac3b17cd05fd293dfa329d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47adafbf2cb4b8738307d255a22be0eb26466e3d97dbabd9d54fcc1738f536fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f3b60be856539def0ac0607d35256eef87daa868b47f5bc83050f0d188d90bef"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    system "go", "build", *std_go_args(ldflags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end