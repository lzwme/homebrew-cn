class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://ghfast.top/https://github.com/volcano-sh/volcano/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "efaa04f2e0347d4fb5de4fcc8db2b6b933666bdb1f39c3c15bafb7eb3548fd56"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7d66b8307e64551536b4b514f0b7fb13b07ab50e6bbb39a05c9f3d998eb5ef7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22873da86567eeb351adbaa8e26d69efddc65b9ec4f0dde696104f8e4e3a9bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df29e5c124436200fcf2ef8aa6a9652413e11836bbea4a4a2c63d930e1093e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fa238f571bed318c5349e5071ab447aa83a0c4a5a6a672bd70ebd4fce311fcc"
    sha256 cellar: :any,                 x86_64_linux:      "ec7fb7beed7e5c5b2278d7c953f99803b4e7de6c51b46a0ea673350b077ab2e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end