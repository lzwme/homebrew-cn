class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.8.14.tar.gz"
  sha256 "183accb11b4da65dcbce7e2a3ebeb1838dc88a5aed07fd186423907fec91a563"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa329db9b0efd280f3f3f2fee81a664265d27deb10bc76327b71f690fea9749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "366b775fec82d802f94ae1945edd7e22542c03a41985a6e6f71716a9365d24eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f59cdee3a7d8e0b72f95d8427acb6fd31a6b2cc739a4c781ac395aa6469ecb80"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f026a198edf09d95bb0add4f7ae6074e4a3c6f3e1949280b19f182ad15ab0c1"
    sha256 cellar: :any_skip_relocation, ventura:       "114669bbec43e1bd47bd9fad4e93d1d366f955f68f9f9bcb662a32bb594b7780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdeda5455d8a1503858ffdd2ada3f91f168d12fcf18f1f359f7a896ed1101764"
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