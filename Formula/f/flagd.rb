class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.7.0",
      revision: "cfcd6bdf9c203770adfacaa5894880cb214c0daa"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d91809611c7b1762d76ecd39e8f011e9f8b44355d3e3838400ecd7dfa60166ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3496b52e87b46037d5d6cc6d55add3e096440c0ff77e0008557957bf7fa42ade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51ceda5e29af30c1fa790a982c75d7460e2e1c5f452c9a3d065af65abd0f332e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d700f86f4e002147904d86b6fa405bd73f59b37fb83a4a7095ed1d4f881cbe06"
    sha256 cellar: :any_skip_relocation, ventura:        "6efe2ad8487a54c5912f96419d52ea170e51df5d10a66e4b3f76a5784e5b4ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "ba6a6dc57dcdef7f693e284af1491d07fbe3faf75a9cbe0f35a34450b4618c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ea771c15785606dc3197c0d8c5fdfb5344719e2be20b29dd989d3d086a4dc6"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags: ldflags), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", "completion")
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"flagd", "start", "-f",
            "https://ghproxy.com/https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json",
            "-p", port.to_s
      end
      sleep 3

      resolve_boolean_command = <<-BASH
        curl -X POST "localhost:#{port}/schema.v1.Service/ResolveBoolean" -d '{"flagKey":"myBoolFlag","context":{}}' -H "Content-Type: application/json"
      BASH

      expected_output = /true/

      assert_match expected_output, shell_output(resolve_boolean_command)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end