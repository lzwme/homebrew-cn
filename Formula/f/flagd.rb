class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.11.2",
      revision: "b6c18f35ec02b43431e739e65baa361baa65478b"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce206e7e6cbd0bcd3407b5dfdce8bad2a5a9d8cc726be122ddf8e52e91c836c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce206e7e6cbd0bcd3407b5dfdce8bad2a5a9d8cc726be122ddf8e52e91c836c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce206e7e6cbd0bcd3407b5dfdce8bad2a5a9d8cc726be122ddf8e52e91c836c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ad37c1671d36547cdc9e6559538244d226e5d5802048617396b422c7e9d0020"
    sha256 cellar: :any_skip_relocation, ventura:        "5ad37c1671d36547cdc9e6559538244d226e5d5802048617396b422c7e9d0020"
    sha256 cellar: :any_skip_relocation, monterey:       "5ad37c1671d36547cdc9e6559538244d226e5d5802048617396b422c7e9d0020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfaa87e49c91246245488d15bd28ed0a0395180d8c8a46c363e12b270f025ea6"
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

    begin
      pid = fork do
        exec bin"flagd", "start", "-f",
            "https:raw.githubusercontent.comopen-featureflagdmainconfigsamplesexample_flags.json",
            "-p", port.to_s
      end
      sleep 3

      resolve_boolean_command = <<-BASH
        curl -X POST "localhost:#{port}schema.v1.ServiceResolveBoolean" -d '{"flagKey":"myBoolFlag","context":{}}' -H "Content-Type: applicationjson"
      BASH

      expected_output = true

      assert_match expected_output, shell_output(resolve_boolean_command)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end