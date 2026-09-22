class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://ghfast.top/https://github.com/DopplerHQ/cli/archive/refs/tags/3.76.6.tar.gz"
  sha256 "a3c9a4aef2311d220e47e517916d08d7be245f59fcf99288357018aca71bc9a2"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e33cbe803ef4209ceefe1c2fce5a2b28bc6a8bb626be44f41d0d15cb3197076"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e33cbe803ef4209ceefe1c2fce5a2b28bc6a8bb626be44f41d0d15cb3197076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e33cbe803ef4209ceefe1c2fce5a2b28bc6a8bb626be44f41d0d15cb3197076"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d62f91d6c978157a017e858aaa9854bb4602b4d74b9beefb4d9742a0f769711a"
    sha256 cellar: :any,                 x86_64_linux:      "3e87547c8c166e36de88968c5caafb7a76e9861c5ac12ae584cd3abab572f320"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end