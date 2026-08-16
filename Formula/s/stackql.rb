class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.10.601.tar.gz"
  sha256 "1c5a15fa3f36bf2f3bea9f45b800d3ef20c9249143b16dad24d4dda9f1724a16"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684e2ee513a95a73641a5ddffb37a6b93ca72afab403410f6ff99288819d4347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e85626d2d6f7a8d3c19a943d7cbc74afab5aa0e042acd3f80e8cddfeda59ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7426caafd0711f8bdace330256dacb6be9c5ce4751e373c398714202d52bd24"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86f7b28ea90239d53fe0f6104ecae32ce5f013093c52da463a18ce86a445a9f"
    sha256 cellar: :any,                 arm64_linux:   "f1f5751a5037463fe856450c7a45efcbbe281a6603082c3be2fb12c3535f5d22"
    sha256 cellar: :any,                 x86_64_linux:  "13776c4e3299d8ef6d790a49f9f2c4ac32a987e819c1bde3c5be73238b91816b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
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