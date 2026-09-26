class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.17.0",
      revision: "b3e07c9c40489a7060ebc5c7aaf42b3cbd1deb4c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f288054b3ec9679d88d37c86629a350795ee949f9dad60cc9152ccef197bcb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "455003dd129f9644b76f0043278ba5b62e08529db35a0115e28c775b49a99b49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e57a1ebe22b45da0dd9af93aca415d09a1fad8d9cd5c891bd284e439732d492"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d7cdce824e0ee5c2f291a6635f1c72a8fcdc099cd214a0ef5f0cb08d90157430"
    sha256 cellar: :any,                 x86_64_linux:      "9edd894dbcec1aa74f91a6618ebb439306115758cbe5234a06b3c8080d8532af"
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
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end