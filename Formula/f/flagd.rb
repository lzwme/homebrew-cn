class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.12.4",
      revision: "cb2b8eeb9c5496272b1f22d63f8eaa5d220707f5"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  # The upstream repository contains tags like `corev1.2.3`,
  # `flagd-proxyv1.2.3`, etc. but we're only interested in the `flagdv1.2.3`
  # tags. Upstream only appears to mark the `corev1.2.3` releases as "latest"
  # and there isn't usually a notable gap between tag and release, so we check
  # the Git tags.
  livecheck do
    url :stable
    regex(%r{^flagdv?(\d+(?:[.-]\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e83b2115cb9670309511f6e1313d54fff6a18b8906ea51157c75b70af7afc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14f1b213c31b4f38b63c45603b0eb697cb370149a5e6f5290d0504869d24ae46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b87cc7d2654b7b28be4dc884bcda1c6458ac59bd1b39dbef5c3b8613443ec72"
    sha256 cellar: :any_skip_relocation, sonoma:        "170d65621ac42851963ae5abf5bcb233af321351731a6732c2bc09881e1d60bf"
    sha256 cellar: :any_skip_relocation, ventura:       "319070d717a541b3fded62e8d1f0e3a04756226cc4adf58eedad0833c0edf740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a56312659d810062fafd8d81bca327f40cc67cbfcfb327ce647226a82a4a6e0"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.buildgengo"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), ".flagdmain.go"
    generate_completions_from_executable(bin"flagd", "completion")
  end

  test do
    port = free_port
    json_url = "https:raw.githubusercontent.comopen-featureflagdmainconfigsamplesexample_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: applicationjson" \
      localhost:#{port}schema.v1.ServiceResolveBoolean
    BASH

    pid = spawn bin"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(true, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end