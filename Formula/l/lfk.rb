class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.12.tar.gz"
  sha256 "3180c660d0563e0c87d4fa03e8a7134cd4eea47dca1c3c51433fe8077e2ddec7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7bb6c99cdfef0fee48d26af5e469bab54302a89d7f7544d5840e57add613763"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81977d774963e67e11e2d5d358ffb2609df95613584794681bd633ffc327f8ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15e8e0a8abd04d0c5ab215900421dbba05871b771d188a0a31d461a37e2142b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ce106369e869022ae7e8bf7409cc5c0cd9b42b0d9db0f44a7e063cfac5f6552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9c1ac95b7fe98cc2cb65d7f3f2280b2f99a445780140b8e6838e4d1adad1cd91"
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