class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "80de27818f484a372b218f2c48b36709eab30e4a908a0e029bc71f86d00d927f"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd9da635985bf1ef379d1f25459c5b912c6364d3931005482d3942edaa095ae2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd9da635985bf1ef379d1f25459c5b912c6364d3931005482d3942edaa095ae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd9da635985bf1ef379d1f25459c5b912c6364d3931005482d3942edaa095ae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "35f35bb4c2eada417a35945b21016ed0a34a71de066f75ba2a27b6281fc7818b"
    sha256 cellar: :any,                 x86_64_linux:      "7966164f59d2298b563f7c41b3aed956002f02669b4c2d60517b87e2554b1e4a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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