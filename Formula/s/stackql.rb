class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.10.557.tar.gz"
  sha256 "3d13861945dba3f5df72522ef9c109ea39e84c4ddb7cea08ef02c58c71a58d7b"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91c6cda2a589c8e818fa3e0182d2be85c132e90b1d10bd75864534351a96e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592b495fadfc194f2747ae8046b517b192f7e48de441c2869e585fd4a69752ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8e11e9a4f3b022d886e40cbb2587562dfd9713191671490466800a7cb3a2976"
    sha256 cellar: :any_skip_relocation, sonoma:        "03803f0aa1c43b2ab9c8bfcbb8b2143a4f8e485838e27b0fa60ffdb9dbd800ac"
    sha256 cellar: :any,                 arm64_linux:   "c05ccd16c11bc1eb0df99dc6fb61b6e05fdcd5e1ccd889017e517e31fb37e7b8"
    sha256 cellar: :any,                 x86_64_linux:  "9c6ce76386fa7232d8608bab427e59a75387da68fd5acc66922261f145dd967d"
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