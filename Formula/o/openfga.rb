class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.8.tar.gz"
  sha256 "f364830d8628e599bd1385015d0ac5bf8074ebc8dd806039edff0e710d590bae"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ce111f9f63012317b8061e037172adb7dc83ec09e25ede6824224226e404b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf35a52413d7145bc3122ff585071a6cb68109d5f775d1d4d3ed40833e78d356"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52fbcf002f22de1b13b8787cb762704c41df30f9180f7386179065b088060e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa78670fb891391687f2d2e8ed8d18d5e6f56911043bc22f71c61661cb827d8b"
    sha256 cellar: :any_skip_relocation, ventura:       "3b50740d5cac93011fbaa267fc99ca87302909aa1b86533a253d1ce9650a6bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53d9a73628f3f8503bfb81be18c468ec7aa038178165ad6fe3d2352909d7613"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenfgaopenfgainternalbuild.Version=#{version}
      -X github.comopenfgaopenfgainternalbuild.Commit=brew
      -X github.comopenfgaopenfgainternalbuild.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdopenfga"

    generate_completions_from_executable(bin"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http:localhost:#{port}playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end