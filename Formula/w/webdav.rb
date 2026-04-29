class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.11.7.tar.gz"
  sha256 "5b0ab4fc0865db95d5143598e71d13e1de34cc945a411e085d29ea7f08b6f43f"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f52faf5e7e9d55a33f16a537aff25d5179ff3c576177534101bfd98ffc8a0e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f52faf5e7e9d55a33f16a537aff25d5179ff3c576177534101bfd98ffc8a0e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f52faf5e7e9d55a33f16a537aff25d5179ff3c576177534101bfd98ffc8a0e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc74258654ace0c02f68c524843e22be52be903e14e8fe685349ba268799dfee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ad5f8438484c6c21b8b41ec27d0f21540f8a54179a35c4e6c64582e4ebe61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f123e52b974e03f7ad59c8ccdafdbab61e37481fd786967ca2f07807cd9ac0af"
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