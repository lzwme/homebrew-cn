class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.11.5",
      revision: "dfd2af993f1c565fdf654506059a128257016584"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c686cc78a33026fe2d5ff431a26504eb9f51981fba941941a01abe0dd32197c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c686cc78a33026fe2d5ff431a26504eb9f51981fba941941a01abe0dd32197c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c686cc78a33026fe2d5ff431a26504eb9f51981fba941941a01abe0dd32197c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df75c6d03de555c5da769f3a9fb87d7390d15e1dcdc701d6ae556e64ef86e0c"
    sha256 cellar: :any_skip_relocation, ventura:       "9df75c6d03de555c5da769f3a9fb87d7390d15e1dcdc701d6ae556e64ef86e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e598d6cc1f60e06302a4064b2a67a16ea128e790c85646ebc0fb355f22cf1530"
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