class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.0",
      revision: "dbf7d2ba01cc7815f9646e25479b75875212666e"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67bb6d8c8642c0eab58fc2eb071424d229c2715d1efaa211375002cc1dd8c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a67bb6d8c8642c0eab58fc2eb071424d229c2715d1efaa211375002cc1dd8c38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a67bb6d8c8642c0eab58fc2eb071424d229c2715d1efaa211375002cc1dd8c38"
    sha256 cellar: :any_skip_relocation, ventura:        "f9ccf1c70b69076de9568b896150ee8f1e6735de9212b0b30db81e07457a606b"
    sha256 cellar: :any_skip_relocation, monterey:       "f9ccf1c70b69076de9568b896150ee8f1e6735de9212b0b30db81e07457a606b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9ccf1c70b69076de9568b896150ee8f1e6735de9212b0b30db81e07457a606b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561941460ebb748db5da8d1451db86dd247df2c7d62145fefccbb065bafa2804"
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