class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.0",
      revision: "b4fc89c758a7083513f4fe0a187f1b7ac5c0a2d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91f25000a0dcb427f565605b429523a16f481b089c40dd54a9b074514b3193cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bebf3c949775757c376453f09c1c080110ab27c078e9606e01725df69160168f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9133f2e3dd6ea918d3c3c00e3c4e6590a67f7389a5ef17f7214131a2ab9af5b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "01fae10bf52d166b73dd9e4ae25440e3117b00e609ffb9cfaab7651397b2b94a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "684ee0952915537ce53c5b2ef5bec57d036048514cc3e4761fe6a8c0249708c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34f7cd59b92dbd93770ed47070cbb82a2f167dc0096248110030c8701e7ac5e"
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
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end