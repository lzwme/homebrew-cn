class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.5.0",
      revision: "529e3e913f2c02adfd4f1bf69455a7f6ba1f8368"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3975a76fd4006dd2703459ffe55472371a6ade6f54d5f738603e51ca2994cf10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3975a76fd4006dd2703459ffe55472371a6ade6f54d5f738603e51ca2994cf10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3975a76fd4006dd2703459ffe55472371a6ade6f54d5f738603e51ca2994cf10"
    sha256 cellar: :any_skip_relocation, ventura:        "92d45720d3d2c13d8c736df37dc663650e515ed87d43b7612fb39608d1024d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "92d45720d3d2c13d8c736df37dc663650e515ed87d43b7612fb39608d1024d0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "92d45720d3d2c13d8c736df37dc663650e515ed87d43b7612fb39608d1024d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72a850283e236586f32aa03eff99baf8c166f9720d83b28282ea168610536a02"
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