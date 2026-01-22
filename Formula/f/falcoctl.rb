class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://ghfast.top/https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "343fdb1c622b63463afe6a1b955a0ad129ea51f128cd4ab8c7c85eab6dfc1fdb"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82cfefec251a03a107d2658ace80dac509f84a31d596de266f22bbc449f6c896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d7d2c0116986bb91ff67c87c39b0380b700acfe1316d63e02f3672b42486d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38388125005a44879322761b0d71ae30ca10e82f9276b2d917494f555d1a888f"
    sha256 cellar: :any_skip_relocation, sonoma:        "59768a28ac90c84fb1834470221911c10643a4d591d42137648aa344ea5a2a51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7da0c9c3071c94bfa6fa2459a5e3ae8634b1b23a2d2eef279ca6ae4cf4f91e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1852833d366550c1699aeb7a9fbbe39bd5ff18bf418519e1e48a7c14af7bbb5"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", shell_parameter_format: :cobra)
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end