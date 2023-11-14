class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.8",
      revision: "5b82d06eb7dc2e0ae14a4635321d2b91162ab3c2"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4cce01bf2dc84e812d7bce2778fe682d86cccd4fdb12a8996a4d46ff2d44783"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2d6d5298b920562ab81edf6f314e0470d4b0e7e1a789af55153804c89b8a9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0232051929491dd70391098b460258f217a19ef57cdafa9b3c667bf89288020"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8c13f0d1a786fb7ba9e7cf4b79fbd8d08b2580ea02010eb13e87bb33638c71c"
    sha256 cellar: :any_skip_relocation, ventura:        "e5cbe63dc46b2344215ba3278977f4d280f027fe6bbc4d9e0658198815b69537"
    sha256 cellar: :any_skip_relocation, monterey:       "b3e16002b647def161bae22c40ffd0eba398244e7e2ab0c9c7b15b6124835917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbe48a15e6908f39da34aae20a53557685e5927218d19f1d3cf31a36f489467"
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