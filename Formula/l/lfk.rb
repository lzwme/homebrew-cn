class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "e34a04fdc226feb4ea0ecc95a394fdf2540d22ba1fa83d29f518c677aab03b0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "380fe07f686d0c9bdeb1ded8ee1f7422932b542246815c96b3781c6ce9a41094"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed68a96f780342ce81da4e3c463cffabc843c0d59b9796d5bdecd794b7674bf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68ba3ce9ddc0922762e22c7b8a31a08a5a705a13644505256a891f4c7640d375"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "352e2cec4ff0ac4f5a31e3eee75367b725bb57aaee047198b582a65b676b04de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "48497c7f56dbb9ad7b5cc874bdb105b40bd3e6270ba6426e66b13fadb232571e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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