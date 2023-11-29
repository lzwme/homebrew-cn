class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.7.1",
      revision: "14929dd5c370a0314e689283508f325e85171fbf"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4925c67f1c758163c6e4d2c344435d57061170c84b2eda2b92755e5b633e5c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72416e61db0ce61fe9c1aa5bf88b244d4a99178cc162c1a88642feddfcd40417"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c292e020350b47b58dbfa1e17f0cea3e28cae3206a677780c86c219c913fa6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b10a3fd07bd65880c9d9644a6fd99a9b506f778069629cd1f09a73d89a7376bb"
    sha256 cellar: :any_skip_relocation, ventura:        "7972e4397e5cecd509a464d6eae0aedd2adc12e9503891da6b97798d903b42d0"
    sha256 cellar: :any_skip_relocation, monterey:       "592fb4a3e5b84d0a0206e93aa722f7c76f679ca40cbd3f0e47af9400b7bbe48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b34eec7e864d1089737aa371c8e8f28e39c1b07a43435177b9a85c99fb98d2"
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