class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "cd7dbc1d68c8dbf386c34d815870b23ec048507a9c0b6c2a820f481f731d043d"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "057da744861b15c6d1440c7817732ffe5f6c5543cd4aa508453ccaacbbdb2136"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68220339ba10f15f75ce76035cd606056a804e263c483388d45c8ddbe1f40465"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b43eccf766a96256bdb474c11b61b4000b95e3cdf46074216e0c0c5e8a1a4b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aff47fd8a0f828f5257f074973569d0a6d193609bb22050c1074637712f48b10"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d1824c63495a1c4d15d32c68cd06a6f12789c7d0bd6866bd7a92d36e495191"
    sha256 cellar: :any_skip_relocation, monterey:       "7bedc90eb674ce4b86dde41f01f2da2aaa50f36fd33f69e5e6f2a8e6d7c16b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f139b3e830a6ba94c26de7cdd1c750bd0dde6dab9dca280e15adf08a8b8262"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end