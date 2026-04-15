class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.3",
      revision: "330f7c1bb753191653d1f8aa93dd03b722e77f6c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fea26f0bcde5034d1d985605d8e8caaedbe05352b990a9dfa5df41a7dc5cab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49dfda98714346998291f07833f2319373f20a86757a1e12ae06af8a49df4853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8a9110dc5a94514c9427e4105ea8b60e065a5cb3c33a0a5c928cf39a1999f02"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7ace7ae8af26db06452f7d7ff38f19dc68b25c27592e898d91bb3162fce8bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d00269599b166b5ad16ff19eeff88ace0b0a96435756ac818419f7ad4f807e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72bd9dc9d5bf96885eefb570e099b6d305c065c2ddd89d2f6fc1296020716213"
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