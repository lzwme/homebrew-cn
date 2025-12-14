class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.10.2.tar.gz"
  sha256 "7bc1535e054e3909c203299eb949665fe1ae50d6b87fc26ea8e1eaa019965fd6"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85007316c5da4e68cc1757779bd75308033987eaa93e9a00b0eac634bd9308db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85007316c5da4e68cc1757779bd75308033987eaa93e9a00b0eac634bd9308db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85007316c5da4e68cc1757779bd75308033987eaa93e9a00b0eac634bd9308db"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8694d01019af945338e82c82a598ec975e6a84290f6d4ac313017a8f95e9154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "329c660ed4195b6f7f842615c6f0e7fc8f22e893faa56afeda661126ba7e08b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ec962b6b70ea27d26f17b665bfbe838d59af0d96b8270a8a868bca547da0c0"
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