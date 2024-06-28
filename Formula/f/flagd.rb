class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.11.0",
      revision: "f2432025f318401ab241c92644c3044a1dd497e6"
  license "Apache-2.0"
  head "https:github.comopen-featureflagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1849b55470e0d35e437ed59c961522728745cf3e482a330f1a669ffadb976629"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6741f1c0d8b387f0bdd5f8b988ce69e2ea29f78f51d8bf68fee085d25228d332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a016481e1cb48a54d2a0566d37227601f44944843c0208222212526c56b59c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e52ce523f84a90ee8160b22ae59a1b166f935319d37aad3f6227d486323d0ccc"
    sha256 cellar: :any_skip_relocation, ventura:        "367185d722337cad4cda34969b666c04987fb4eb8690aaf3cc66c6c78a9b6935"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9127ff9c9d7a16daac9bc2de91ce617392de27efe4f42fa393264156ea5f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e121d02925d007e002564f3d9b84a99e6fecce631224efb967381ed89e7407"
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