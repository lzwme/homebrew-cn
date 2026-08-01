class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.10.582.tar.gz"
  sha256 "0941cbb0ad99d6130efaa1ee6f1bcec996b12c15d4f8c6a8e941336c7256614b"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cff493a75fde39e7bde7d94c1c5b913904a781952efb3f808701000c5358c69c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e35c6ac0e2e7350a9230ed6a59c1697df8d72bbe69d0ad936357feaa75a1389d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293a80648ead66dac19c71f5e7fd1e27eb8f40d1755f0826be7ea9740d780203"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbfcae5a3f571a42814b144bc6a34b7497971c466ce3b234991ade970c4428f5"
    sha256 cellar: :any,                 arm64_linux:   "83d8951b5037312a49276a636bbadabb2d28885a25710ba0170701be60595309"
    sha256 cellar: :any,                 x86_64_linux:  "dc93a7378c8bd0d26414710c8ce04c799aebbc681f06afa24acd870733ca8c9d"
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