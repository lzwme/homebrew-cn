class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.8",
      revision: "c0a2940aef33f8558aa6ea4941ded74f0a6f6e83"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "814122a9227046449967a977f8830af34e18f553b08366cbc13181877b088275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d57436919de8a8b469a85a9b8b7c9c2aa8f92ca838a06d6a256927611380a6c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03a7fe00d793638d63d956e9c5b4ef594e85d65f5750f4fd53805be64f433355"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb92699d818222dd91d3479b974eeee960e1a0cf3ee95c8b352fad6a2d3b2c85"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b4452fe23d5fa98b71c5795037688e017c7f3fc0cbd92f8dc6385af7eab9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9623a14a95475858f9cbaf516fb6a5bf06414c20d7da3b173d40ee10a346ba3c"
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