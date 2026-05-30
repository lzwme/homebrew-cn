class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.10.489.tar.gz"
  sha256 "6a633d2251a64d827a3ada50abaa192bb18139cd559cea593fff2c4ca188103d"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01455a12cce643ccecb4e37e82ca64d3f0399559b61471e388e3158b2ec9e44a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f85b652121f83a51834195c7293ee5a0f47ab08080c017b6d5a2cff00af458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db00eb8f3e7a1dcdc61f32cfb7f71dee9f3a7fa308d75189c808ae37219be99d"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f3eee5d42a95d1b9fdd4c240a1ef0ba2ff221191db237d29e9085f0b81231f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa957e7c9b5987852cd4714caa52aeac57d7266be0e016004178c049a4210ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec00d8bd9ea604c0f1c76da52f62c88de34c19099719762c46c55d8bde29b20e"
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