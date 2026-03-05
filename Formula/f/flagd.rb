class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.14.1",
      revision: "068d886127b1e06fa3ad18fcac35fc52dc26a28c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6a7bc2160b629b166096a3902410ee0c3c1913c2c45f3dca5db8a0aac8e6876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8797dbe828efb8ac5377efa18a005b40de688156e9320f745374357194c22238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b19015bbd2b7e754e0f0fd6ae270b39efb9f69f503e19a0de7c6ff025a92d9c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe51a9c2e5ba3620b9e6bfaa26068215f1f4fbfc6d7496b3fd7d2e343633c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa5e8eed3722743bc10da727cec774093ede51114cb05dc1be7fbb4119af0f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0098039d5544027c2d6204bc5b2fffa23b765af94feb808535b493356a02bf3c"
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