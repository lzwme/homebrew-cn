class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "dfac846f592517b4bdb2a6fedac555ec887064c50c2f83e9b4d467d080e6ae30"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08ca20a873c3d9dfcf315b1fcfcd30af03339b685be80f8eef765b21d65f42ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08ca20a873c3d9dfcf315b1fcfcd30af03339b685be80f8eef765b21d65f42ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08ca20a873c3d9dfcf315b1fcfcd30af03339b685be80f8eef765b21d65f42ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "38754cc4bbfe0276b6850ee3c6798e8f7da5514f727bae456637a0d91c6a4235"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01190e7578716a60dbe13afae3282656d9da069d3251d895abb9fd56f337cd52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83bdc185258dd4b41d8292f02f1b75a1e2e69a7ae468f3ea08b116449673dfb5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hacdias/webdav/v5/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"webdav", "completion")
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