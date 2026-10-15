class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://ghfast.top/https://github.com/padovanl/portop/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "bca5a8f6f592b9e7feffdadaa551e7b7d81ee57609a178e0e089b4260edda5f7"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62461d22fa3271310eb49b15aebd65bd159d4bf62136887895db003b3948b5b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62461d22fa3271310eb49b15aebd65bd159d4bf62136887895db003b3948b5b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62461d22fa3271310eb49b15aebd65bd159d4bf62136887895db003b3948b5b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b36de0245e7e2b3232e46cf83a4253ee9b6dfd69c17405590a2cd24d3b595803"
    sha256 cellar: :any,                 x86_64_linux:      "aa614983f548f629fdbe0f5916122c97fa85555f2f6ed8ee117cab70f1170a78"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/padovanl/portop/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portop --version")
    assert_kind_of Array, JSON.parse(shell_output("#{bin}/portop --json"))
  end
end