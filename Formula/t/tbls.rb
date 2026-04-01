class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.94.1.tar.gz"
  sha256 "0e3894237996087afa4179833be74cdba5d832eebaa897e83a953e3068cf4acd"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62388c527350c5adde959a287d74f7e445ae3f4d468342bd185b3f2a3a0ba482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40011bda8af50558f3d31b535f0fdf773b8e6b911f01d393b60dc56b08f5d09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27632072235c09604fc7c409a5022bc9491724022c3d04b74ba6ac5978017660"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf17ac74e57f8adef6c92d94b971e955f16c6694b3c81f3ae1a1a12a09793302"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9473652f219547ab0e7a59a6d3ca4fb7d0473573de07e2aaca3a494602a4764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca097c2f187d160769fb0e8e6f36b14d0759adff8206563ba7142c32fb0cb8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end