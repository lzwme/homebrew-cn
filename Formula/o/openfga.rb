class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "f7823c3ee6910afbce9c99153dd34457c10cb04e3019319f1d09ed1da1d11c4c"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfb6923d1b22eb0098dd894a2f3c4addbf0a74f15df4afbdf32187124ba43763"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0dff7ad260414c34c6be04c339f1029f2e6e58988ee0c920ca2925b320c160f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a6a510e3ae506ee692ef3a5962a576c2b02b1f6f6b6889644146706faea0c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "eea5c83617e750916ef1687d11dc9d6c3b0b85f500a0f338a48c5d630c07c0c0"
    sha256 cellar: :any_skip_relocation, ventura:        "8f7fff1067da6b329e4ba7fc757e689852a6718079236bdd49f2de33619953c9"
    sha256 cellar: :any_skip_relocation, monterey:       "18f06124e934ca9b7d577bc4375167055bee3ed2afd336cf7a7e06284c41e1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051f5bbd6767e860fb2fc3a5d1665d70ab3d154cdfe2c2ab13cfa3cc7c8b2e6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end