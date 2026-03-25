class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.14.4",
      revision: "947af795f83f2d5c0fa28cdf14e7e8c826cd14ec"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4d79d77fa2571659d2e855e36cad854088f0cfee30d3ad54da113c5fdf526d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d164de1e19ad16746cff0423c46d849e8a370c88e7f7e384eaf1ef130f65655b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5166e7a47865e909607e295bd0e88060269d8d7ac14d8568b05b6a8e7066d4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7147b53e9c7c0283fb45ed693f79de5b8019f2158e15c1a49fb272eb0eb5283e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c63ef4c7591f59c1de457824e3db8ed60884e1454df6f672deb274003be5994e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "719199a17876c0369152c3d1d633781c7df372ace6fad60afdcea2f64233a1d3"
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