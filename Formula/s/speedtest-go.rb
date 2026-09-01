class SpeedtestGo < Formula
  desc "CLI and Go API to Test Internet Speed using speedtest.net"
  homepage "https://github.com/showwin/speedtest-go"
  url "https://ghfast.top/https://github.com/showwin/speedtest-go/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "01c518f34eefbb6653a33538bb27daed4ef56318741b3d2d5412e9a3d81bed6e"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "484fcfd3ce7d194a61e8d267b9977923e9dc3bf1ca2e6a35116438addee8adf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484fcfd3ce7d194a61e8d267b9977923e9dc3bf1ca2e6a35116438addee8adf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484fcfd3ce7d194a61e8d267b9977923e9dc3bf1ca2e6a35116438addee8adf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a37a7c4c5494560ae81eecf3e6ac6d9ca15e6d3ffb93292c898cb4f3a6d527d"
    sha256 cellar: :any,                 x86_64_linux:  "d1cce4a1844e43ba5d95ff69598c417a0c5316a2830ab9e53b2acd05c6e013a5"
  end

  depends_on "go" => :build

  conflicts_with "speedtest-cli", because: "both install `speedtest` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"speedtest")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedtest --version 2>&1")

    assert_match "Available city labels", shell_output("#{bin}/speedtest --city-list").to_s
  end
end