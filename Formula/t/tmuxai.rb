class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "7713f52ce96ac968821b28d5d324719fabd9780cd31a9ff04f95d359d56593f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3780219366957e661a319389bc8131a37bd81399fc06cd1feaf64a38a9169855"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3780219366957e661a319389bc8131a37bd81399fc06cd1feaf64a38a9169855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3780219366957e661a319389bc8131a37bd81399fc06cd1feaf64a38a9169855"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b6800d7f78f05f5af4fce6e3c46a573fadc2fcdef0bfa5f01cff5a5b17e0d35"
    sha256 cellar: :any,                 x86_64_linux:      "bbc346094a39c2f2045b23798fcfaec347b83d18dc7fe7342e86fd6161ba5cf3"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end