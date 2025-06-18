class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.16.tar.gz"
  sha256 "be00254a940c5effac7a6b6fa521be1c40d1df9dd65554d050654c45453f116f"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc6ece7b3e990f86ca70a2ab18d8a94a1ddec36bb3e6f38d5ed6d1c799341a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda7d744fbf2ca6efd59833ebb0839f64e39a82f42b266f3f7a08e1c47f178fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "436f1cef70cb26d6d675e08651c59b5d60455f142ede5a6950cc9715118e9a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fba3db49a7b9c6183fc9943819a5a516778fbd87039b06cbff1daaee057893e"
    sha256 cellar: :any_skip_relocation, ventura:       "71a4ca872372790eb1fec5c8196e44e075fda8596725d195054aeaccdcc6b373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1572c7d05aa03f4647672eba182698b1394f0eab0e9699d653788232a6f5eb6"
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