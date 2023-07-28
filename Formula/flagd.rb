class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.1",
      revision: "e3e03b0af2ed3690aae8755facfe2bc8444c4f50"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71fe90a21e4ad5d356631cbb692cc3f0c8e2cfbaa126561bd78fcb762550533b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fe90a21e4ad5d356631cbb692cc3f0c8e2cfbaa126561bd78fcb762550533b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71fe90a21e4ad5d356631cbb692cc3f0c8e2cfbaa126561bd78fcb762550533b"
    sha256 cellar: :any_skip_relocation, ventura:        "ac79113161c27f6e5871265ef0035c5658b92c273d31bde1241860476b5c6e7e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac79113161c27f6e5871265ef0035c5658b92c273d31bde1241860476b5c6e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac79113161c27f6e5871265ef0035c5658b92c273d31bde1241860476b5c6e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a72f22dba660bd3e73fd6d58f450c325041dbcdcd6228a5f0930cdec26ab3f83"
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