class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.5.2.tar.gz"
  sha256 "71f6a3998180cb11a7e5f4be12633f03edd4f04fa166fa9c40c0e14f0470f41f"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be593b333be247b4e0a0ebc75ef5f7c3d3a933850a5e91fec4c1d0537a3e7550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcf90b7f9adf52e426a946b8c9977e0f1d0473fd72366646d4bfb3d5c8888d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35552e6138bea512de48e67543fdc317eb518fa7c7c87434aa8602cfd215a391"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab31c9cfe1a1e02e9a6ad4233287627acefe36d016a5e8e3e91a66093d181982"
    sha256 cellar: :any_skip_relocation, ventura:        "5796cdc3b5ecb99a460dbc05e020093bc4cb7ae7c8407fa4d2c5ec3dc5a36f94"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd72c068ff494ce2c884af5287c617bba4cf84b27067ddd20d4ed95cf11dc0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d120faaeee1fd3ab97c5777927cbba275fd6bd8a12c93500dbcfb2906e6a64e"
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