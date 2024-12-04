class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.11.4",
      revision: "df54b6612448608df642fa6fe644388558fd0843"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aad1403d2e3411555155203a3de9f5804c9bc4e523890b519b8ae9e7b96c080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aad1403d2e3411555155203a3de9f5804c9bc4e523890b519b8ae9e7b96c080"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9aad1403d2e3411555155203a3de9f5804c9bc4e523890b519b8ae9e7b96c080"
    sha256 cellar: :any_skip_relocation, sonoma:        "e89c25008ace122e2824ae632c2479d0584b9e2d530bc195daaea6a162b9fcad"
    sha256 cellar: :any_skip_relocation, ventura:       "e89c25008ace122e2824ae632c2479d0584b9e2d530bc195daaea6a162b9fcad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6774ba531af3a7dbb559e4fe5adefee8f4214829993ef4de62a711267a4fafc"
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