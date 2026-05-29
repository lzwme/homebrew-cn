class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.6",
      revision: "3aec90a1fc88ff1569e6dde1c3f30513de37d35d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29c4265712f80ee3e9743fe9ad575d40cb9a45cf3d6cd6228ecd8445b0a0c7d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74aa64d123593aeb82706547a2bf6fa6e3414ac5eaf7fb2067317e13eb43fa6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa00ddd461f7af7db7271c668f6ddc00161e17f370f6ab8a73f93238276bc223"
    sha256 cellar: :any_skip_relocation, sonoma:        "57121c7c364f6213e123e6f7243fe349969bb59e8bf9fa792403d8ce04456819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4055fc089b6914d6b8446f014449f9959cf32c3be0faa6665c2652efb3161fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcae794ee99f4e8318fc6ec5dc93c47a02a49175f3409a0a6b35670595d2cde1"
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