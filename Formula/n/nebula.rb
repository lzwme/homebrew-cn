class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://ghfast.top/https://github.com/slackhq/nebula/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "0031d1ddd616f5e25dc29f4b67d6a0c58864251be17095a68d15e4d0edb54843"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a1a71de2d396f17ad9b7c6f01466bda50637b74a7e7f43359ade27dc8c68131"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a1a71de2d396f17ad9b7c6f01466bda50637b74a7e7f43359ade27dc8c68131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a1a71de2d396f17ad9b7c6f01466bda50637b74a7e7f43359ade27dc8c68131"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "450bfffd10089e45c19ea0419a0aafc8f060697b633f343e3bc2033dfc56ed9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "62d17982968ef5fd447579e408e755f22d8fda5f94907d17b97ae945c55812b4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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