class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://ghfast.top/https://github.com/slackhq/nebula/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "8d490bc345ccbf25ce4697b6df9bf15c6352768ff2643df51450b5783c651c10"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a0787147b89d3cbac13c240ac552ab12e58938f8c028d6763641c19c6cd1de3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0787147b89d3cbac13c240ac552ab12e58938f8c028d6763641c19c6cd1de3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0787147b89d3cbac13c240ac552ab12e58938f8c028d6763641c19c6cd1de3"
    sha256 cellar: :any_skip_relocation, sonoma:        "175b9215b4b72e852991f23cad0518899f35f6c7e6ad600e4c5eea4d9d00fe57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d4d1fc24abcbed9b789fed0629e37fed0999f217fe75fee8a027b34b5af8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe898fe4641737603476d61e02edbef433c3c0f944e3772bca104b620fb3889"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
  end

  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/"]
    keep_alive true
    require_root true
    log_path var/"log/nebula.log"
    error_log_path var/"log/nebula.log"
  end

  test do
    system bin/"nebula-cert", "ca", "-name", "testorg"
    system bin/"nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~YAML
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    YAML
    system bin/"nebula", "-test", "-config", "config.yml"
  end
end