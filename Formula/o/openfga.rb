class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "eb08f45418d90216151258f113aee6627fe4914c4f6e3aef59dac3ab016fffc2"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f762958418a45bf3f329eb80c4a1299fe6825e834437dcb225d72887973a159b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58a912a741f4f2920fed5feabed6f9154110e4fb689b5716662f902f3802295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efc2aec22af8dac200433fd0f92566eedd61dad268845f74eb0b58fc249864d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "582460caabe653ca53ba9c9da1aa6dc6ff319e4c7268546ac6c8e2ef749a078f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c0de8de2148402cbed35df90c2763ebc1ff5bbec1942ac750c191d51daee12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a74be1f5faacc5c6f8847141fdaff9177ea4aec19ec3efd7a4ab0d44a3fb48e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

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

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end