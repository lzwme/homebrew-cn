class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.405",
      revision: "74f6f365c0d8372c66fb5070d4309eead7d57709"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a5628db4725d032305c74fc8e03842aea2530b9c91c602c2d97e1ec43dfa0e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "977817c9aa00b41c7dbd122f67447f306e0201445381c3b8b9de1f397e153bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9af5bc8891c14bd66703f4f7ea74ed11b5d44b76d5c8b0616b38072f96799bb3"
    sha256 cellar: :any_skip_relocation, ventura:        "814bc1ad04515c70f4bbed6549cb9ec1d6a41e194941e705b35de968620cf900"
    sha256 cellar: :any_skip_relocation, monterey:       "0a03ac7f09c94c7004dea781d4ca79e6e0794e4b6d14be6efb41b8df3e3a8fd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e20570e0b7b0c041c1d16fb7c578c3d4fcad89a4c083f6f2784d3d0b35787d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22e81fb75a39be5730cea1f1c78be7be3cae53373490aaa05c1f1e1aa7f74e37"
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