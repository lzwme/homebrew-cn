class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.18.1",
      revision: "21c850300d05a3617a877ed6d0bb2d7b8c6b7204"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06d70d8ffe839f995084f9a852d58fa214cd363c05dc0975b06b381776e1e4d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88201249054dead0f518de54a9f1567fc85f6b4de8ccf85765073ac5fee80b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43873275dfcb954c354fb1a71926006c6030e4dd31f3590bb496a167ce218dca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "921ba747f08e3a50d5d4b6b492b0576d6edea59a99278d723af74bfc451c6b99"
    sha256 cellar: :any,                 x86_64_linux:      "92478a3c8cd647a041d7f6d2e8a675c05b852c720200272fd9575e3e78f1648a"
  end

  depends_on "go" => :build

  # `test do` block runs a local flagd server with flags from a remote URL
  allow_network_access! :test

  def fetch
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    system "make", "workspace-init"
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

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
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end