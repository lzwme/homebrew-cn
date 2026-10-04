class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://ghfast.top/https://github.com/hacdias/webdav/archive/refs/tags/v5.17.0.tar.gz"
  sha256 "5723f8f9adf403fd513c731d6470465f3128632ae23783bffc4727c057f395f5"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78a1729987453eb7f0b1f753d54deed36f57dda8190896f2c9c8d09051b72ffe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78a1729987453eb7f0b1f753d54deed36f57dda8190896f2c9c8d09051b72ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78a1729987453eb7f0b1f753d54deed36f57dda8190896f2c9c8d09051b72ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae43cceabb25b5f900b05c67a25fd43d1065a6e56aea9ae68c4a4638a579b689"
    sha256 cellar: :any,                 x86_64_linux:      "3a68a691f93bbb73ee30bbac105f931a6ef171309d77b50d96d300968ba48d9d"
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