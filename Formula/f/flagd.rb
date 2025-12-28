class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.13.1",
      revision: "5e4218cefabe40138f20d07f0ca0665d4ab34c09"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e89948218eb4104ff49ee880910e9f98692abb474ed193ba9b55fcdfbc90324d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6342aa169b15ab4c92579b1f76281c9b411801ff2053fb9c13357dd3d004c83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb75ab72a14eafa80260dea605892f62dd70b5813bbe0773968b205c5e571ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e36ea31fda9f026adb5d7bdbc2bdf24d68547c018a055d9b16d0a87e5fc5b72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7612f9f667d24ab2aed06cbd0607dd0c455c2d1f2cb35dbcfc5d5a2884426af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c1ef02e1f0c3303a4a4c410fc9cd1943e2c80c35f7c55799a339c870c2280f"
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