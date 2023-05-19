class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://ghproxy.com/https://github.com/slackhq/nebula/archive/v1.7.1.tar.gz"
  sha256 "24acbab518e0fdddd4619fb9054d23ab1c3ed71e80add38466f4276041de5cad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d89e59cf1f3a2bb616fc6dae8e1232065433e000e0fbb09d071e77e6b5ab83f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d89e59cf1f3a2bb616fc6dae8e1232065433e000e0fbb09d071e77e6b5ab83f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d89e59cf1f3a2bb616fc6dae8e1232065433e000e0fbb09d071e77e6b5ab83f"
    sha256 cellar: :any_skip_relocation, ventura:        "32019168ab485a9047418331edd404ba99d420d2febe7b07ec34caa8a4cc803b"
    sha256 cellar: :any_skip_relocation, monterey:       "32019168ab485a9047418331edd404ba99d420d2febe7b07ec34caa8a4cc803b"
    sha256 cellar: :any_skip_relocation, big_sur:        "32019168ab485a9047418331edd404ba99d420d2febe7b07ec34caa8a4cc803b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89266fd531efe65d4f312743c1b796451ebeb2c5275597f19c6458f132940423"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
  end

  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/config.yml"]
    keep_alive true
    require_root true
    log_path var/"log/nebula.log"
    error_log_path var/"log/nebula.log"
  end

  test do
    system "#{bin}/nebula-cert", "ca", "-name", "testorg"
    system "#{bin}/nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~EOS
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    EOS
    system "#{bin}/nebula", "-test", "-config", "config.yml"
  end
end