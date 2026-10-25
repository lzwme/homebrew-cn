class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.17.2.tar.gz"
  sha256 "d4d84822f0ceb5255cf7b360e33218b3ff2f0e54c2167c39a392565561a11f96"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d703528fa6e9d9bbe3a672a9fa86d8ec2223ecfe0ac1e7a4613523fe475be20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d703528fa6e9d9bbe3a672a9fa86d8ec2223ecfe0ac1e7a4613523fe475be20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d703528fa6e9d9bbe3a672a9fa86d8ec2223ecfe0ac1e7a4613523fe475be20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "967b466b9e4033bc53b45d3bf51abd85df66c7952c576f46bf1963462c4a1496"
    sha256 cellar: :any,                 x86_64_linux:      "c20b4eee368f43158b5149c36405dbd755a0bae930a62e945e28d6a269569944"
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