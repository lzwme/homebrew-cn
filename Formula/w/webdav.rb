class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "a52ef8bf27f15074d645c4040152fc46e497bc44a03361e19fbd84f813a36f4b"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d0e6e2ef1a49261ff77b6d642ac14d8d47eaf320cc5a933ab5c8177cdba45ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d0e6e2ef1a49261ff77b6d642ac14d8d47eaf320cc5a933ab5c8177cdba45ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0e6e2ef1a49261ff77b6d642ac14d8d47eaf320cc5a933ab5c8177cdba45ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbbd4ab99bf8fe2b66a6e9bfde11c877e61a3c988b01df2c391d03e8fd3b6895"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20d35f0667489c7b9592ecc1532d6df640357d03f2dda6f53320c35a2d1b03c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb40930cdfd8de966e9a865539a4f7a7a35d989a7d7dad810e6969408bf4451"
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