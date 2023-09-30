class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.451",
      revision: "5374a2e79bec3c5694ec3aa91f8ab6a210b693a2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50b94d28870cb7a7ebf9bcd39a74cd2124d1ecd5b97dd0dccc2e4e2f44ce39c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5f025a16a9c6e34bdd08464c5e8bd9e14e363918b58c2efdc6125f02c11a2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a4778273894f5c505039f26bf99328f19690f5fe1bd174635fdf60de660b52"
    sha256 cellar: :any_skip_relocation, sonoma:         "c08abfc4b9a4ce67025dffc45cf7b1264ccc67e320fe98d5cd64523001ed0763"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf3022e9ae786236ad33687c7f2bde1652e014dc49680c838f7510485461b15"
    sha256 cellar: :any_skip_relocation, monterey:       "94ea6a76a3e60c5fe65e57dcc28dc4df1a527a1e0110bc54903d6a678c45bddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e125379575bbae46af11d485b57617b427884e7d55ab4c36142dc47af7a01a6f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end