class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.7",
      revision: "0f732e2217408f930bffaf7b6157185f5464684f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b938fdf0462b11d5eed948699e6f181980d7d9dbc331c6eb652ec01fa00d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15cc26f12bf6ec9cc5348e3d99f413e0616d5a8e447b888c53303a6e276c6ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c098e983161b8b5a60f5a01db32a967209a2076931436cbc8d841f68697167c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe354e18a021ef20e0f1014c106b417e7a5faa456511ec1d2f9374b155715928"
    sha256 cellar: :any_skip_relocation, ventura:       "685d98c8f7117f8c8c5ca4787fe1b1846fa47d052b6c9ce1db377d999495432a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d491b85be6ae7d7e3282f8722f188db64eeb817953588ccf89343bae3af92aa"
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
    generate_completions_from_executable(bin/"flagd", "completion")
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