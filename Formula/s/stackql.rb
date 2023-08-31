class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.414",
      revision: "38b107f84de84de8025c7c95d9fd2cc5401fb636"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2afabd2f413b861e672e5f31c37437896878655d395acde21d7a3cfb326955e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1dfde0eee8d8a8bdbdc45825a47f5581a3a5723e06aa5e8892a31d72b7dd4fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "873fbb75ee6d1de3e71673c7f30f186ecd7c37c8b16ef88b4a31beffb3e4e4e7"
    sha256 cellar: :any_skip_relocation, ventura:        "f34b254e41512739ff5d2da791a843577e0c8c5ea50568be1fda6736f137b1e2"
    sha256 cellar: :any_skip_relocation, monterey:       "17ace16649ea9a62362994459113301083d93d40ed6e83b3bffd2ad94e6e682f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f5959105506e11178ef13d90963af177a973aa0687fe1eb1db7dbd5fc668db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f28b2633c15d48bad4d86ed9a9afb2336f3bfc87bef3bde9b02bf1a14db9320"
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