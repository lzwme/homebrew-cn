class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.5.1",
      revision: "f5ecc5413753edab7c9f42e2a917ce10f81d63d2"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b53f491b5d9dbdd055bc702e815c7bab732f6dc36bc0ed915207d7f940a5d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b53f491b5d9dbdd055bc702e815c7bab732f6dc36bc0ed915207d7f940a5d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b53f491b5d9dbdd055bc702e815c7bab732f6dc36bc0ed915207d7f940a5d88"
    sha256 cellar: :any_skip_relocation, ventura:        "d008cca479ed888ee539a4003286095950c07101df264e94ad3e51cc93c463fc"
    sha256 cellar: :any_skip_relocation, monterey:       "d008cca479ed888ee539a4003286095950c07101df264e94ad3e51cc93c463fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c71e458fdd13d653f9051eefcde0fa1be7853fcc3ec74a942864f8970a3ad601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ff814b377e8e9093b1a3dc3305a6b2206fc031e365507b2a3fe44d2fa01f22"
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