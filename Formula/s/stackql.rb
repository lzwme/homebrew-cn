class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.686.tar.gz"
  sha256 "fe0fc62d2d00567ba0cf33be640fbc1edfa551f9d7b6b505c3e40f0af96d9a0d"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af57a9e0c58594fd090d1f63a5e673d40df144d1a164f6fa3fa79df1ab07b576"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c300ff60a7db47508a33a8571926e11127d5f9f4dc9a11e2be81e1ea97d1523e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add51f92e8afd2e84325878e6ecfd0ddc5482f39f9f37d4be0f68fec04489722"
    sha256 cellar: :any_skip_relocation, sonoma:         "76b3c3c7686c5d756d028bfbf4f19fdadfa3edd36382b31863970c25ccfa61ff"
    sha256 cellar: :any_skip_relocation, ventura:        "0e365006e1ac76d01126ef50e1d2af52fa6e9b2ef94ac51539c0aa07b1fbd66f"
    sha256 cellar: :any_skip_relocation, monterey:       "d2830d02406de4f9448d434339973bd42b4a740ae7b9a04089d493b22b41113d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "003b1823331edcc039ee0986f6e00e633ce43e832913d3b5c1677cbbf5014b71"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstackqlstackqlinternalstackqlcmd.BuildMajorVersion=#{version.major}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildMinorVersion=#{version.minor}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildPatchVersion=#{version.patch}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildCommitSHA=#{tap.user}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildShortCommitSHA=#{tap.user}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildDate=#{time.iso8601}
      -X stackqlinternalstackqlplanbuilder.PlanCacheEnabled=true
    ]

    system "go", "build", *std_go_args(ldflags:), "--tags", "json1 sqleanall", ".stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}stackql --version")
    assert_includes shell_output("#{bin}stackql exec 'show providers;'"), "name"
  end
end