class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "32aa2b366ba113c08c08b063cabd60785a7e39582b279a2d954bdc8113dc6b40"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0e4dfe900cdcb073d02981853463279b9e7e3b3cae2a1e7a5ca4655f7a05e76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b18dc83214fc52e017861df486aa022d5464ed23a186b128c6232e394f762ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63122cee7b619a1dbe571f64016c572dbf05af94f8c96805120588ed5766b7cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "80f6ac4bbebe4c10bb4c72bb60d77d8c607f25227abe93d374a04b4cce9936a5"
    sha256 cellar: :any_skip_relocation, ventura:        "105eeee520795e6b9255da6e0d86f24d66d87aada14dd87bcd6d8a9da7459512"
    sha256 cellar: :any_skip_relocation, monterey:       "a1a4ea5b78fad50835eb960fc57a8c322a13e52e801341cb892bd923ccba989e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8fe1e78b1576378630b2e959a2705eef34b5d5f6d8223b48c0a42c5d8c8e86d"
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