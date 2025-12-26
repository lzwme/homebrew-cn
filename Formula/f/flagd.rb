class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.13.0",
      revision: "814a6aca1ebac04ff9fe570767d91ed95741643b"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e46eb3cafe1b0108f87e1779f1da8f32618386aa784fd3ac3e7e5c1602fc623"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3566b2e1b1cb17ed294432ac91b5602412ab4bd1d0c68c8f5a18f24a7f73ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d62f7c53b947c3319915a806820b0ec3d15500cf8cbdefbe16234d4c857664"
    sha256 cellar: :any_skip_relocation, sonoma:        "becf43ae6fe6218c60187ca2c18e487a2988ecf6e074a9b9bdc694c057aaa742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142038a46a86607cd46734198a00ec9c9aa1f96b47ed1c39bb3f10f148f4e64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "083c9c7b807ea3fac120156b2eb380184f8fe7ac78f37065ff6a72dfc788de7f"
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