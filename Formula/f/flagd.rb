class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.7",
      revision: "1c7f7bc7c7612332bc873cd0a9bceefdbc5b5096"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b4d9eac3bd9235d1a2a184ce678bebd43e265cbe6262f9f15d90fa8911865d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0efc94cd9aff4ab4aaa4cf41817cf69d68c74353f1bb42670829deb80b9b8f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f7333eed995fc59c70ab4037f93ba3ccac28d2b14c8be46afac4533f007b38f"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6936c80564e086842a21c3d0efade721ad78c5d19d18653d30242e97e8c5ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8890b0a7e414472305b51692215d17ae8668820762f6e91320d98d274cf66eff"
    sha256 cellar: :any,                 x86_64_linux:  "85ea2bf1afe343f751e060d8eceeb6a6c9c5533d41499fc36771305aeeadefbd"
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