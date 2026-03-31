class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.14.5",
      revision: "d9b5aa2fccc09d4f938fa9cceaa8d53e9140b8aa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b778314485452683a7642c74b4879d54979011f16b2e8de52b7f39647e85039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260f0b161caaead8348f0764719dbcb110d07c840429ca609fcc4da7a4aff7ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df95d8008199c7dabe768ab38924b96c4058455fb8732dc92ea4afbf667ced1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d90c232accf8dab041eed02afbb3b59b2e3ef244b65301f13df3b7c90ae4fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e846bd69ce826cb40a48b8c1294f4d60edcbe52760e5fbe3724f05eb006e5c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71236b2fd3639789a9b29ea5434450460a4a87085b1c356b60c937fde5b2da2"
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