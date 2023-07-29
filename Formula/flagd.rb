class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.2",
      revision: "53028b57f9d3045dd8e98dca5cb0d7c2813bb957"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2223c5d2c3d94777d86703edebef4bf8e748680a563743d8bb039fb4050bc81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2223c5d2c3d94777d86703edebef4bf8e748680a563743d8bb039fb4050bc81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2223c5d2c3d94777d86703edebef4bf8e748680a563743d8bb039fb4050bc81"
    sha256 cellar: :any_skip_relocation, ventura:        "1e3189cf2533076df26d31e3b6517348a76e07d4ffc12e48d8f5a8a1e2e095c3"
    sha256 cellar: :any_skip_relocation, monterey:       "1e3189cf2533076df26d31e3b6517348a76e07d4ffc12e48d8f5a8a1e2e095c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e3189cf2533076df26d31e3b6517348a76e07d4ffc12e48d8f5a8a1e2e095c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cd69027edae1a024fbb5f0885f75208d1fce70fa748e2eaca79d2c2e0493a1"
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