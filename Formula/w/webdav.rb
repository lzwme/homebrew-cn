class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.14.1.tar.gz"
  sha256 "eb0d10198f3a15cf917485f9542c8f576917e49cb07f372c5de94fce15cc1849"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a2e35589f8924011ab3717ac8471ebc1e3dc256ca1118e7f43710b88144e1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a2e35589f8924011ab3717ac8471ebc1e3dc256ca1118e7f43710b88144e1ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a2e35589f8924011ab3717ac8471ebc1e3dc256ca1118e7f43710b88144e1ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d89d442f597031707225b2cec01f9151f4002a5ed05599c58fcdc8028f9f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec3f0326ab34db24002807476379ed968731304d21ecd1921e8014db36bb90e"
    sha256 cellar: :any,                 x86_64_linux:  "94f75ffb5cbed23cebaa5ccde5a66f0d2869bc4f058636b65703fc702d03d503"
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