class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.7.tar.gz"
  sha256 "527461e14b5a1c12c07185dd6990f769dd49f2087177ef86cc1ecd3493cd76db"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b875d0b005787c894d3e8b037d1831d64dcd5e8cbbda539d5e3e6a3697d46c85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4fa834c16eea1813fb224727a411e48bd579177e502f9f68b8c0e3250014bf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59d869ee7bd1007a9ec0392d8c167c3f9fe7f7467b8947b55ebba6d2e393cca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43ef58e28c2ef56abc1d4f469c2c73a5a8515aed67feb985ceae777b49ad754"
    sha256 cellar: :any_skip_relocation, ventura:       "15c35e5694351c8b6f742d5dedc0d08aa9d57ca055625e5ce20386e2ccada1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6702eb418848fb65a45a8ff3fa08579b7861b95cf505ec61657118e050011260"
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