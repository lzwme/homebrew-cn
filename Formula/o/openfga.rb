class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "a1ffd29f022a3129e5d20b13e73e41e466627d1f4d9d088e7bc4a73c85079981"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f6f7db9b305bc80d2c1508b8e9a0950ce488abcd1b7aaa4845379507ec900ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e38c8e050539e6cb56b58f3707e3316305615015e2d446576b826d32da4103e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68f9fcf45e28f11f7b750e03b9ba54738d20c762ae4e80a33a90f3d7c851da48"
    sha256 cellar: :any_skip_relocation, sonoma:        "126d3585015d48a1058cced9ad15bb3b979de5cc61ab17c3a4c94eb5b63d7c50"
    sha256 cellar: :any_skip_relocation, ventura:       "c55743bfdcc3395d34439d3c14ee270a7daf004adfee82ebcd388d81bab04104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee2a262d05fe96ba5a473b303e7ebf6692e7481e0887db3c7d3caf416b15a0a"
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