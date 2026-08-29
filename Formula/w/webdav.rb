class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "fae24d7cd606679dc7d09541237bfcad232cc857b18200549daae035a7f751cf"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9839262c76d1096fbb1382196cbc12e2edad06dd32e8c8d16e93691fd0053fb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9839262c76d1096fbb1382196cbc12e2edad06dd32e8c8d16e93691fd0053fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9839262c76d1096fbb1382196cbc12e2edad06dd32e8c8d16e93691fd0053fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b3b16ec43e647c18b28618a3b3d800aec19a1ff3afc8cb7d599a14bf41aa6b"
    sha256 cellar: :any,                 x86_64_linux:  "a03808147023f4d7d8d3d353a71f8970057833ec8ccf8b9e741ec4bc0bb2e7dc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/hacdias/webdav/v5/cmd.version=#{version}"
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