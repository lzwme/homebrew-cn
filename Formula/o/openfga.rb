class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "331ab7a9213cfd12fcfcbdeebf2f8b047dfb478830c061aa56601914dcfc856c"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "228bcef759e64f63366c86a20d3bd6d177f478d585368bea6885d64f04a3a213"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a3502a6866a774e426b4af902070443ea6609aaa308690f74617fbfe6e60c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be21b27ccfa6ff7a14c36a0d7dccf7aa902c2be002b00854140372c30d47ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a534156c92f86d29a462a6d0de361e06acbe247eda85c908d22438f195530cc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "753c2bf53123fae3e16567e96561d471a4f030e37543c9802e7f7527e65725dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73c24c6123b2e6ca49b2e0385b93bba4b9684b541e2d8e401c77d2096f5fb38"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end