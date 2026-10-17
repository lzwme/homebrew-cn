class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "555275f5f1f45fed93e9e134764072fb5ff24ecc1c3f8fb9c79eea7690524e68"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5f8715a1a9a22f182620203e6d74319ffe2b4e9cd7c9793eed041604363688f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c24d0d14cd75cb90c0d397edaf63e93b5b87e67b087afd7f42bed514e7ef9b41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3c0aa6a7b27eb4f44360d004252c989a9d0f3a6049a3c3b0de726c235d49cba"
    sha256 cellar: :any,                 arm64_linux:       "a7b5ae09cd6781884968bdead26aeeab636cf6a342050fe0c0067e738dace316"
    sha256 cellar: :any,                 x86_64_linux:      "c36d0e197406560803c2550263b9f3bc631b25cc8021372b980509083f5e5061"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end