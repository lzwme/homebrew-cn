class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.4.2.tar.gz"
  sha256 "2f2d6b0f98e1ac1d7033ad4f5930d153c4b6b9b762e628f822935778c27c43a7"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51ff7bbfc3b1e64ad81b56390826a7679f2b667fcffe10defd528e87be506a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "692e9ec3ea9445d3aa921311576c50e2b3af4df0f19b07c0631bb001e8920c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01cb3f3fd0267a5592db360b652671bc8396daf5ae1d180a6df1376755a89fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4367ca8c721160c3ac409974aa8784c27b4586d0e7cd2c517a097b4c9a767b5e"
    sha256 cellar: :any_skip_relocation, ventura:        "ea72d2da2f1dc6336c2dab7d7a9347fa0c8e0e0e9d1a1f263bc4de8e126cf4c7"
    sha256 cellar: :any_skip_relocation, monterey:       "0902320b30f950ebb4315510097a725e74e3cd779ccaebaa8a633b357dde1777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "250e41d01f9494731753f7067be2164f9318bd8967b27d1d18ea9b3031af6847"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenfgaopenfgainternalbuild.Version=#{version}
      -X github.comopenfgaopenfgainternalbuild.Commit=brew
      -X github.comopenfgaopenfgainternalbuild.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdopenfga"

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