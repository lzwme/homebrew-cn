class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://ghfast.top/https://github.com/stackql/stackql/archive/refs/tags/v0.10.591.tar.gz"
  sha256 "36becf02c2c7f5d0fac8aaa3a96f0cf2ab5d6e492c7ca660c1fc929692082087"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bddebfe8e6edbfec85980d48e8cddfb2560ae103337f34ef47db67e654bea963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d725dea8ff613ea5dfd6dc594b0c859e6a8e8d87d17f148a4e1b17e621e7fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f86742dac43ad476d9ddf0cab26d3221a4ad4c20c1b82b4f211d3c108b6549dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43297e3b2f3e05cf63584881fc6c9bf75dea65887dd9fc10a901534c564427e"
    sha256 cellar: :any,                 arm64_linux:   "53a7a0acaf25ab718b41abdd3e3e5d69303a13a0903809306d4569c6b6e69859"
    sha256 cellar: :any,                 x86_64_linux:  "46d84af6e87360ee88f2f015be56e2678f2cef695b5361d7de7789c21953554a"
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