class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.496",
      revision: "c0ca7c50d8129c13896ab26428b2b12671ad13f9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d47f20e8d7a089819a8d2eae9969da7ac8080a48ab4be5e49c72a7d8b26eee7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ef6b4672e95f83cf5a938db93b316e451bd72640cef6c25d5078c8b8d378c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112d46d5f3b50eaff5f90276730ddb94818d630da29ef38b423a198101012a07"
    sha256 cellar: :any_skip_relocation, sonoma:         "319d84e1f938ded0e1cf7ff34480d4647bf816fb30fd2f92a9c431b8e9e33170"
    sha256 cellar: :any_skip_relocation, ventura:        "27fdaca54fd1d7eb39fa0e6383bb3816685f1dd632aac11d4adf680349e8837c"
    sha256 cellar: :any_skip_relocation, monterey:       "e543d6000b7b849721eba050b5362b2e6240dfa1d7df8561e506510c9d29621a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3d0f97be452fd3226f432fcb8c81d4f5a0581022d766a89162e7742a1c4526"
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