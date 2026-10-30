class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://ghfast.top/https://github.com/buildkite/cli/archive/refs/tags/v3.67.0.tar.gz"
  sha256 "17c909f280db7f86fd18cc9632ca726846c10e8727145df435cae6c6f12352f1"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e0d47e740d3b46274705803d5a672f5703a915659f237e28c4901573814afa6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e0d47e740d3b46274705803d5a672f5703a915659f237e28c4901573814afa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e0d47e740d3b46274705803d5a672f5703a915659f237e28c4901573814afa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af772627ef4d9aea579d11fb5ef725bf9e66628dba524672778ac7270d0fc9c3"
    sha256 cellar: :any,                 x86_64_linux:      "fa7ce6669d22c642221ef5ccc963e38566d6132737ec2c25fd0e842fff4aeb18"
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