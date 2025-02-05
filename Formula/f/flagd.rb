class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.11.8",
      revision: "166c40a43877e707697a746964f78b1a90967b88"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73249d24d5e23dc79af8aa5a73b15afdeb956d0fa0eaaf4f1d4cc09f4ec39dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73249d24d5e23dc79af8aa5a73b15afdeb956d0fa0eaaf4f1d4cc09f4ec39dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73249d24d5e23dc79af8aa5a73b15afdeb956d0fa0eaaf4f1d4cc09f4ec39dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c52025f247667d7226c59d6a5a18dfaaf2bc44f21c4647643d5b4d8204ec56"
    sha256 cellar: :any_skip_relocation, ventura:       "d0c52025f247667d7226c59d6a5a18dfaaf2bc44f21c4647643d5b4d8204ec56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a8bfe479748c3638022b08ae5bd4cd23071370759cbd2fb6dccfb91cc324df"
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