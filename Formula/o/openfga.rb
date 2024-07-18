class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.5.6.tar.gz"
  sha256 "04b75e5437cdcfc41c661e1e1605047d41dfddedc42254e2ec91e74434a7b928"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e87640285a3c230308f9d45849a62c8070c27ab72237166ccaf33fd4724acef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f938cd1a0f6cba8c9c5112f9f879e676adb1eb40a9b845210f61bd3fc6abfede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85875b4731a287547632b10b593537a944f235a86d9d1aa392ded1172d305bfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b713531d019ea5fade1457fc92aab972d3c30464ed1d6e00d6aafbf6c0c2510f"
    sha256 cellar: :any_skip_relocation, ventura:        "3f0c17ff249f809c81014749d30949bd510c0e438811caf3cc61e4155c0f72e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e90c99675fafcfe364418ed51adf56079bb022266d861e5619cab890abfb14f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4110741da8fb0c2bada1624b52f317790c4f308e4a36e8fbf0369ecfc83ef93d"
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