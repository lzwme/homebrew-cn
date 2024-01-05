class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.8.1",
      revision: "9bc9cae340b67605215c94398e0b226855249866"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30d36526ef21300c4caad5d90af14ec4a4f9f24249980ff30b452f4d6e55bc55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fb9082018021972f7e2c72ce70e52b3dc8c94c75ec79973f0f2b29c7742194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a3c5d249b81c344d8f66684505c1cb313330f6b08cc734bd4c3c7bd0b43faf"
    sha256 cellar: :any_skip_relocation, sonoma:         "f95c16db88d6ca9b6a6557cbe69d7afb53f1bf169b6663cf8b91d624de16d090"
    sha256 cellar: :any_skip_relocation, ventura:        "9b56c39286074daf3a2d2239e8c6984058c5ddc2c02db5219640eb1b8d5edc00"
    sha256 cellar: :any_skip_relocation, monterey:       "ab525a044defcd36356c5bf88a91512ec6e6fc3d38feff69eec65c1bf0fd24fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f85d3cd82053c2545622735c26bed04d55cc1caa7876d74a6f74270a87e6fd"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".flagdmain.go"
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