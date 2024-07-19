class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.699.tar.gz"
  sha256 "4b80bede28e06cfb522c5b6c41f6a118f1b8896559a767981c2e78872ad927cb"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15aced1e8efe9e586c94b6218aa61486e91d2b9d3a6d0a2af32790b4d396cf70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9541d57d0aa30e7b0941fcd781b738b90fa85a47481c1b61859263f76d95132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf97dd03801cc9ff87b627348b6e7f78babc38efb0a5c1731184b845b19402da"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd2b6e10d9c1c1cca9efc86a22b7094aa66987c26cc67c783d8fb0d85c5c1a12"
    sha256 cellar: :any_skip_relocation, ventura:        "8be6d66aace2f8015ba08f1587218ee8a4a4eec125db14eca29de92addf6983d"
    sha256 cellar: :any_skip_relocation, monterey:       "51ae03237c82e1a372e9b306be013889d50e4c11b188131fcefc1461c1f060bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b9f3f43b15505d574c1dffdafd85fd54397b3edffe14174f4ea056345ef131e"
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