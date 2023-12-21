class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackql.git",
      tag:      "v0.5.527",
      revision: "3bc19827ea94cee207d80544c7f12d9fa20ac694"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e525690859845d5ccb8516a99c226ef504eb4d5d700ed94847ed863afee42dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45dbf76e29f3094e6799ebb3cf8062ea498489996c8b51a30ff1c219e7d00a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b796f791d6004a5a901db1f16161a64bc6ebe74ae180dbb4411ef270b38bc902"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a9f9c9f4949643f0049ea1d451caa3646dc415d7bc16e73fd137ecc5fd6bd3c"
    sha256 cellar: :any_skip_relocation, ventura:        "dba2c6ce55cebf8bb53526031e82187526599dd043348d3b051a84e2dd1da6a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a789f74e253f580c8a0bce3e119c8bf1c731600d3cdf249cf6c721fc238797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a83b4c81defbb131c0f91741b2e07604b0ed229648848867ffeb1e46cbb70bd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildMajorVersion=#{version.major}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildMinorVersion=#{version.minor}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildPatchVersion=#{version.patch}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X stackqlinternalstackqlplanbuilder.PlanCacheEnabled=true",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", ".stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}stackql --version")
    assert_includes shell_output("#{bin}stackql exec 'show providers;'"), "name"
  end
end