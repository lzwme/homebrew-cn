class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://ghfast.top/https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "6c9bcb389a93382aaca6bce79596b1e6691d520d3b267f40edadd3ce51d79362"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8259105cd1f8fc474091f1623d5412d2bfbbbf40524de2472ad1fea78db3465f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "921fe4e4b841917f89697f3d6620ca3c11960987c50ba2c554898c68b5f04415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4810016cd002005132cf2787fdf17af22c332fe87e57f9331c8712a9f602b5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d329baf2da7724dac97c556352a3c57f37f030f10587a371aa53ec998901190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9698450552f9d6526d7e6b15f8afd722293949abea8a415996bd7deadb7290d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c78659a916d5fea52215401d07a3aaf4ef0adfbb80b6e67d9e991c78fd58d761"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end