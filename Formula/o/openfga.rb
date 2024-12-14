class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.2.tar.gz"
  sha256 "47d469658ce288427cca7f52d7a04d68cf1f80012220e4f30ffa058f8f887932"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f646266594e2da5039a4bc0dbaacb7b13f6e9a69a02e1f7f9c3724534441f5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f646266594e2da5039a4bc0dbaacb7b13f6e9a69a02e1f7f9c3724534441f5e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f646266594e2da5039a4bc0dbaacb7b13f6e9a69a02e1f7f9c3724534441f5e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f561bde394258cb44edfbcd26b01643f1b15b869b608192595aeb58fab8189e2"
    sha256 cellar: :any_skip_relocation, ventura:       "f561bde394258cb44edfbcd26b01643f1b15b869b608192595aeb58fab8189e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2f5875233b20349e38990463604bcfc687dba3b7dd809fa53968af243d8b5f"
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