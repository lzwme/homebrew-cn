class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.10.474.tar.gz"
  sha256 "49b1f34aef5119bae13bfebde226af7dcc48db2823e993ebdd6a8cb9c9c724aa"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d01fd3485d536f05a90752b5e003a739f07c383548bc7810ac943d8356df2ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539091e9f5d38859552ca3426fd1b647d57a25db193d35b69352bf70b70ba37d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a452df40e3e2632f40777b2f5817c8e173fa68948b40109d2511294893735d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "1576d501adc5e6bcf8daf4e893e6ab9371d11dffcc14ea29a09c299f3e29d5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae21ff1d0bd3bb6ba7079bdbfcb9ffb2c6c2d177027630a830e089dd5abd715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c21e23f58d7509611a3f6046688edcf527e360f56cef209f6d67f77af63ede"
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