class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.0.tar.gz"
  sha256 "23634d23f30dc4a15cf050c73e4ae9ea6be53522951c185b30c369ab7c27be94"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "193c6efe91c0ea17adc25fd51437b5beeb6db968da8d506e3c5835ec8acfb113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "193c6efe91c0ea17adc25fd51437b5beeb6db968da8d506e3c5835ec8acfb113"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "193c6efe91c0ea17adc25fd51437b5beeb6db968da8d506e3c5835ec8acfb113"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceb5aab455fbde2afdd1d45e47e208b015d6fdae63117efca652a80ab776ae25"
    sha256 cellar: :any_skip_relocation, ventura:       "ceb5aab455fbde2afdd1d45e47e208b015d6fdae63117efca652a80ab776ae25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a143e3604873ff5a001a0f8fb70842361cb93af23d69ef094a4e6b09b108b7f6"
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