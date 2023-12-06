class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.7.2",
      revision: "9e6e8d77eceaa8b75c181951a672064be649143b"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddd6737a67542b946a2ea8f37360ac6d2a980b45fb015bcfd0f9f7040c516cb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7517555ef6b1f65e150897f4357eb60b331e77964894edd7961ae691b990ec3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe924962eb30693a8b0233538774c548ce5cffbe5e5ddd62b3419ba7b884ee3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "91a363288c3400ab5fc239826d121638570c3afff9f2f98686bbf53f241ac0fb"
    sha256 cellar: :any_skip_relocation, ventura:        "b97f12e9647099e68746f498c95a7478d030478b4f2ff6289c30a08ca1b04ecb"
    sha256 cellar: :any_skip_relocation, monterey:       "00a5922b476a0966983abd379d5c3c548e21aaf2be626f56b674dbd8ed8c7ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "263f2e94661c0f8ca0dad38b1a3f7b57cec880bbecadf2c93887cb0cac86619c"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", "completion")
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"flagd", "start", "-f",
            "https://ghproxy.com/https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json",
            "-p", port.to_s
      end
      sleep 3

      resolve_boolean_command = <<-BASH
        curl -X POST "localhost:#{port}/schema.v1.Service/ResolveBoolean" -d '{"flagKey":"myBoolFlag","context":{}}' -H "Content-Type: application/json"
      BASH

      expected_output = /true/

      assert_match expected_output, shell_output(resolve_boolean_command)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end