class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "66b7c16d1e275e9b172cf00ea80b57fa399987c1758bb4097b5c8f5f77db63b5"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93ff09e7a28e79607f60f2e7cc9011263b3cc99dadef369cd15875ec8d5ff2d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "580e609803c9a403ab1e9e3f4d0b241f4f12cb86d30cb3386448ddae26a5abc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90037de5b7c608da7a1f1f96952312e09bb68c2535c58acbe1288667ff30301b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eb1ab743ab1544a614436fec516b788aeb150843f4587ef6d7d5a25e5739d41"
    sha256 cellar: :any_skip_relocation, ventura:        "9085aa8278b7ccb2d146402568be20d4d9502740b6738e67deee598cc3305920"
    sha256 cellar: :any_skip_relocation, monterey:       "7c546b5dc72e611f0a551582e3e6ef77ed7a1fd6fafd09eb2a49cfb9b0c335d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "877387b59096f2c4d1f56d854f4c618e23c6f7f7b78071d6d379243f3d8779a2"
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