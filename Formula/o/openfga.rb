class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.6.tar.gz"
  sha256 "f7522f8cf20a83e76fb0586cd324ebb513a89905417e55180842d2d43cde0ee0"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a9aa5788e844dc46c36a1bf7ab4111ea938679f3af5df864565752a5101299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3833896da719ffb6d9cd97379b66411876dd8431ec250b73c1d7a802f5d53c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3f6807809e42e3ebd2b795ff7a60331d8fee496e2c0853c6c7b7a36cbe3d165"
    sha256 cellar: :any_skip_relocation, sonoma:        "f251ed5a3a14c54ae7cf2aa22579dfed384ef65498f44a80a7205acbd0c2ebf1"
    sha256 cellar: :any_skip_relocation, ventura:       "04d8a12a9bf2714b8a0201e49612e225c095f2570cc56c90a2589cbefffeb222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581870b353f2bf946a40247f40269d3786cd25b6e923a83ef7559e2d8ccd14bd"
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