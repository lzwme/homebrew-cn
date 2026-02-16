class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "eeb807f08a75696453cd3f0f90f94d542dc3e9b8c138d9d996f97e69f135c4e2"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "819cd92f483df5cc0e2d16c46ce4b412d5d68eb33b076c5a52180da8a3bd65e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "819cd92f483df5cc0e2d16c46ce4b412d5d68eb33b076c5a52180da8a3bd65e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819cd92f483df5cc0e2d16c46ce4b412d5d68eb33b076c5a52180da8a3bd65e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a197e7bbd16dd3aaa0614ff165a1148a80e20a0f9050ab4a0ddae1b341b80a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f42edaf8d049680eddab6131cc1089926c8c64c9063224f770adf9afc20b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ac6ce1aba41f771a1b4f3ba075bf821f8db892c97c1546d2c7aaf1d2c19598"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hacdias/webdav/v5/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"webdav", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      address: 127.0.0.1
      port: #{port}
      directory: #{testpath}
    YAML

    (testpath/"hello").write "World!"

    begin
      pid = spawn bin/"webdav", "--config", testpath/"config.yaml"
      sleep 2

      assert_match "World!", shell_output("curl -s http://127.0.0.1:#{port}/hello")
      assert_match version.to_s, shell_output("#{bin}/webdav version")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end