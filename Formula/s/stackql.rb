class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.6.32.tar.gz"
  sha256 "6f1b2a50363be83b75959a6eb7c874ba870cf8c03075bd795b545a315755019c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285f2a7008850d71a8febe2546f1578bd1bbad62d448459111d9bdc2d58f52c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "736d342a9910148d7799b0fa628a5a81c0f3973597b0cdfdf88362b7af2dd6b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d47ce2cac54c69569c99c788f535919d85a2a5981a74c37400fe6f20cfec2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "803eaabef4536490df1df17f6e3ac74e19baf74a4377696e7e32ca8553159349"
    sha256 cellar: :any_skip_relocation, ventura:       "81ba7fe4dd2c471904ee8290dc25bb908ad5401a7f5ba4402e0f8bcda829471d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca6a6447746a230722d7cff2045991996fb613a9d43a3cd3a5e6cc15cc35a5bd"
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