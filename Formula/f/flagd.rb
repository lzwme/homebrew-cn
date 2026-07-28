class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.16.1",
      revision: "fce10902c22e820a0e392514a6f4530479f77e51"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  # The upstream repository contains tags like `core/v1.2.3`,
  # `flagd-proxy/v1.2.3`, etc. but we're only interested in the `flagd/v1.2.3`
  # tags. Upstream only appears to mark the `core/v1.2.3` releases as "latest"
  # and there isn't usually a notable gap between tag and release, so we check
  # the Git tags.
  livecheck do
    url :stable
    regex(%r{^flagd/v?(\d+(?:[.-]\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "001750bc1487cef3930552f6c34870c3896241459e4f05a432735b15002fd683"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d884d0629dcef129e23e2c424971e1972bd03387e1b1d87afc5602f820abcc44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db0bda30bcc2c1685a8797182d240b9952a48da5af8ba0fd4abba1e9dd0b9519"
    sha256 cellar: :any_skip_relocation, sonoma:        "874883d502f09bf67dfd77bd2827b4fc5af87d2a219d832b428776cbf45824c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0bef49f5f817961d772a95df977998192ce2df1052b9f27eca326436cb6e2a9"
    sha256 cellar: :any,                 x86_64_linux:  "54ee87cd0f6f88532a6e6eb91df467cf0c4f7c403ac38918355b8ca84f56729a"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    json_url = "https://ghfast.top/https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: application/json" \
      localhost:#{port}/schema.v1.Service/ResolveBoolean
    BASH

    pid = spawn bin/"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end