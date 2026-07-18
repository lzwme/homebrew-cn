class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.90.tar.gz"
  sha256 "49aa51d3d3e06303ac5c9a59f4e2b53115a436822553009b115d489af80f510f"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deeb0edca0f1ba06c81bcf9ba93e90ba2e591b5d9ce443fe2d1986f25ba6f936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deeb0edca0f1ba06c81bcf9ba93e90ba2e591b5d9ce443fe2d1986f25ba6f936"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deeb0edca0f1ba06c81bcf9ba93e90ba2e591b5d9ce443fe2d1986f25ba6f936"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ef53886120e1ff2ea267bf741c0bbcc25c00a27abc5f58ff1c1a794fa1df52c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3593995682663ba74477a6265a15ce5faf276482cd9b6990e439167db045f979"
    sha256 cellar: :any,                 x86_64_linux:  "9db7d86fee09c4384a46b9b50d4a7633c7e744c9a201943a304215831ec1a02c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end