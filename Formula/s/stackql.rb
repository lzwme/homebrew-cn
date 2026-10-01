class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.12.732.tar.gz"
  sha256 "02bcaefb0dc3aa9beaab3daa9d432684491c940094385c448d097fb1b79ba490"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6869d4b12727a4b1b64725b79177881df57d1b5ae2cb327fa5691ecc0e78916"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6869d4b12727a4b1b64725b79177881df57d1b5ae2cb327fa5691ecc0e78916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6869d4b12727a4b1b64725b79177881df57d1b5ae2cb327fa5691ecc0e78916"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db27712796f62a21b8ab345768ec7ed8f0d005254ed9792cdcd5238dad163b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b3c634c1aa877c47198c2e6c3d68bde1db2e982868202903fe860ebfe4149402"
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