class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.12.tar.gz"
  sha256 "2e938bec6576429fcf9196b7a3413c8314a2f4fe367dc55dbb83864eb485adb0"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5447d55367b64e98640e25bbd3b1ae59d38688cb6ff96e270f8b0c0c60b81ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a9627a82fc9ab6511760ffa908432e8f6c87dcf533eea02cb9ab71d712ca85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34147e3d892ca5d756f4374d66f7005c924a831fc68371a35607f7760ce6dbd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a42a78962855c8c3beac9ef9cadaea914406f8609f17fa702caff953e503dac9"
    sha256 cellar: :any_skip_relocation, ventura:       "530198366665eb3c4070e7ed11978d44e76908a62a9cb52f1624536a8c1ee648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9941db7627c217009327e186e1f5af7aaef1bae8c169786f39f310a2c5a87f0c"
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