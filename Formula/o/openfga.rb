class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "70da55ca9672f75c52bdb092b4480b1b24121745817981aea62b33afd3b8843e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae4a93288963bf3729f198a49f0a2fdf01a944738680d96195e98a72c0e3489d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54aa63becc7dd9fd9b314ed00fc5219759d816e3448c34a21027671267f2c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822d48bf9106f9a255fa466687ae2e4395ff0108972a4d8408bc81b1fde97eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecd276221c3e29e5c19b355cc2a53f006d094ccf8aa2a5d53ca9468adab06af0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0812690a6b66d89f3aaaa6110f40d960218fbb753f8c803d90d27da03c89eb03"
    sha256 cellar: :any,                 x86_64_linux:  "11a7075f39cba6d071cc6c6aade0fdd86bb05ec43b26fcf59dcfe082fa28445e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end