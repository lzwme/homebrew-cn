class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.9.337.tar.gz"
  sha256 "4248f8a9396fbf776a9751843a5fe2bf4d54d687461d93092b6c1bfe0c7b80ab"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85ba0819e8fd0158368afd27cbcd00067b344c300d6d4f9a65d76041a3b46a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a413dddcc4851df4b89b09bcb35ed87fe485a060dcd99002baf869cb7d63e89c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1903c46917ff38e6531df4462f7f215b290810778c2bfd2466945bf89ba788f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6754e8a0bb59d0784c77a2f9bb7c682dbf1228c91efe5a86b2d78de0286f00b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8252a7c3af82a1bf7fbf69ade274dae4836c6937accaf22f167d0c8895afd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "556fdec21eee4905b426beaa34dfbabe73d3730a06f45b7b045e970fc693bf44"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    tags = %w[json1 sqleanall]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end