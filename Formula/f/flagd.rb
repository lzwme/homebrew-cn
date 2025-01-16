class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.11.6",
      revision: "ada1c070997eb958f46cad8dcfa7c724a8bf1e01"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095c5db76bcb9b5ccb51224a4e7451815f57d83c21059f3f5a49aa0a82b90b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095c5db76bcb9b5ccb51224a4e7451815f57d83c21059f3f5a49aa0a82b90b8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "095c5db76bcb9b5ccb51224a4e7451815f57d83c21059f3f5a49aa0a82b90b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f43ef20e25fb2e2738a4765f4e22e17ad107e26e4dcaf3d9f9aa4a6b48f1eaf"
    sha256 cellar: :any_skip_relocation, ventura:       "0f43ef20e25fb2e2738a4765f4e22e17ad107e26e4dcaf3d9f9aa4a6b48f1eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c77fa2cd0ce476ffee021feb4c94fda269156b27be11fa1edb7dc5ff2e96b0"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.buildgengo"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), ".flagdmain.go"
    generate_completions_from_executable(bin"flagd", "completion")
  end

  test do
    port = free_port
    json_url = "https:raw.githubusercontent.comopen-featureflagdmainconfigsamplesexample_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: applicationjson" \
      localhost:#{port}schema.v1.ServiceResolveBoolean
    BASH

    pid = spawn bin"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(true, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end