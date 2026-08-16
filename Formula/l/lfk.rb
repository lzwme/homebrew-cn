class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "49a95c1bf5edb0d37dc7f8e409ed09ac697b2755584f525bbb930c361585059d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e81916ddeb8643b88f4e7c93d33995346344686cb3f24fd758f7c8eccc5f59a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88f9e3d8c20c5bb81873df1bc455863a015f4d7e8e82326ac24f32f7f197c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2e8816d5364d9cfb53b8ee648cd371a6dc3438b2af0025f3ddd9c0e4ef8cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "52006602e6a5d2c16b2a005f7351e5fb65f9c0d6e77bcf82b5227b84d9aa4cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3a75fb38cc37797f8f94409c0df7153cc9302137d0c3f5c4adc4a6c02634a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b739b68145e0ef67752141609ddde36e572f403e72815b96678b9206a772b1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end