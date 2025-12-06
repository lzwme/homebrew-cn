class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.10.1.tar.gz"
  sha256 "66184b4b66f1b95f395583eeb6cff6bd9464f09e91b22e623e5c488f4ecd1d69"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3e272d9adcd7a830aba462a2365f266e6ff9a1dc0880c22300b3f79a6b7a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3e272d9adcd7a830aba462a2365f266e6ff9a1dc0880c22300b3f79a6b7a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3e272d9adcd7a830aba462a2365f266e6ff9a1dc0880c22300b3f79a6b7a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "33cb937fa56581184f96087a0d7b7d44607e7d6aa9688684cda88ceb59596dd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab1f9a2002422215d263f27e6d4ced82e5a61d774a67d0d6d1fbeacf8c20db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a32097dc3f480096dc502cda7592a4b15e312723685a94a5339b3df5c471f4a"
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