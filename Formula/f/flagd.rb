class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https:github.comopen-featureflagd"
  url "https:github.comopen-featureflagd.git",
      tag:      "flagdv0.12.2",
      revision: "e199e33d2186439916abcd23dbff613490a9aab9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c066be5a107263b9cc028220307aeeff7eb9096fe1b7cb416cdf3068f506344f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe0398c2bc1174beb76905c3fb24c361931fb3a748ab1223d977b5187429f77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9fcc8864bc14be12151519dc6221d760dda2c84326e6b103c6ee1386e0432f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa595dc8bbec473fa39742825bef3096efc0a4ea510ecfdaf7f64941c4d044d6"
    sha256 cellar: :any_skip_relocation, ventura:       "54225ad1e4cd2265dff77d6b3bba4aac1a85de8891327b98f38763b9893fa2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71bea7b68070adf2c4d4f8617c2934b8c37f54f6d62fc7039c191f7adbe5bec5"
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