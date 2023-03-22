class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.4.5",
      revision: "85a0f0d4d97d9388dcd291b2a96e8bbbdd53c2a7"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e8fbf9098abebd863b89cb72c4afd6ab48a7be0c6b6c6dd519e437ba01e31e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e8fbf9098abebd863b89cb72c4afd6ab48a7be0c6b6c6dd519e437ba01e31e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49dd5b573cfd4a42ab4bfc1c86f343bfc2b3302ef1f2a64a57509b56af58b2cb"
    sha256 cellar: :any_skip_relocation, ventura:        "b72cf2fd9ae8fefca9d43e29ba0905d818b5612858b7944641f81d84d4007214"
    sha256 cellar: :any_skip_relocation, monterey:       "12229ab5501967892337f0c1f4ea5d23fd01b1875870e2e4fb13783bbbe6d7bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "12229ab5501967892337f0c1f4ea5d23fd01b1875870e2e4fb13783bbbe6d7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b6c99355333cdd44ff4304323269a3586baee37eee8eaa66449d28ce00dc23"
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