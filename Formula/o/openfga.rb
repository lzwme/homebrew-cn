class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "be1c5d55f5e995a5a3e583b79e2a8a1520685880ecac7c5803e315f6fb8eaba0"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8305162d066457ec745ed12bc870c421714d5b7a7b7b67d618b2942db4c08a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62cc86f923275e77fb363d2e1100f9d0944241acac79467fa6fdd075ef1b51b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e696a1ed521a941ece240b2dd5497a24ec9f2390f8fbed094e3d9f25f19271c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45268bb575c3dadb1eba4564ca98bcfcc3f833d62ec5548b3df8c9fa59a5871d"
    sha256 cellar: :any,                 x86_64_linux:  "afe92d44c986eb30fcecac8bf3dc9c0f353635bcea764d56d49870595089c366"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end