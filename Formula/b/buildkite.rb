class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://ghfast.top/https://github.com/buildkite/cli/archive/refs/tags/v3.66.0.tar.gz"
  sha256 "cff14147b1ce8c02eb0c9a8663fda32b2d73b60ec6101e259eaa1a4e7187a97a"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbe2abf0be708ab7608ab2aca79226b02f64b92b0f2a40658056ab64f54e1a7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbe2abf0be708ab7608ab2aca79226b02f64b92b0f2a40658056ab64f54e1a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cbe2abf0be708ab7608ab2aca79226b02f64b92b0f2a40658056ab64f54e1a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03d3af56bd5f343af070455a6b86d67a6e755fd5b556297690b76f6d28921ba8"
    sha256 cellar: :any,                 x86_64_linux:      "3e9fc24cec942cc300319707e7a2e5de9c09d5ddcc95edd96a640b65a1536a51"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/buildkite/cli/v3/cmd/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildkite --version")

    system bin/"buildkite", "config", "set", "output_format", "yaml", "--local"
    assert_equal "yaml", shell_output("#{bin}/buildkite config get output_format").strip
  end
end