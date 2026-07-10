class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "e954f38b5445bb77150e5dd59181c58dc5dba0ac56b34a5b4909062381cdfdd6"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74d434d7512f0678c47293845251f9530886e4df7dd9184828f1a12b0abb5801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d434d7512f0678c47293845251f9530886e4df7dd9184828f1a12b0abb5801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74d434d7512f0678c47293845251f9530886e4df7dd9184828f1a12b0abb5801"
    sha256 cellar: :any_skip_relocation, sonoma:        "a583e24b1e30029c9604da4b64b46659db88cdbb8f6fe24494056585efb0546c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee0b0b4a8dc173bbbef258930b507e825d20e4f78d6e93235ec3d2f4380e2933"
    sha256 cellar: :any,                 x86_64_linux:  "24f9d129165e1de40b2f417bb08b738e32a6a439edd514a40dacb2dac6bf20b0"
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