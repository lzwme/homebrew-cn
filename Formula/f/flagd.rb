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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49c13bae1152087ffe3c9d4e51be5bf3bad9700b0bfd28719f0829edcbd6f417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4feec482c7fc2780e09c8b30521e66b0f9b0d15d027bffa54e7d93b9e8e416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e2ece020d9270e258a326fdb5dd1039979d88149defe88d2471f5191ccbf2e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dfb90814b3d2274d6ce10b42883e0a94e6b889e04f87cb7df2b677698ed0c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "068c362a05a41aec4eb0452cc470ac77afa0c34e388eb38b91cecce37578269d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5470d0577304e84d024dcad2789b7745379f8dbdcab68ecba9d27ad4b7f2eb98"
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