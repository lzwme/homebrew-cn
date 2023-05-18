class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://ghproxy.com/https://github.com/slackhq/nebula/archive/v1.7.0.tar.gz"
  sha256 "df195fd3c1de6d1c43dbdc5aa1197594589054d115991360ed3f95e3cd3732a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72786585797061a8abc9d36a13bb7982f9b3398bcd192673944ca4347b34a463"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72786585797061a8abc9d36a13bb7982f9b3398bcd192673944ca4347b34a463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72786585797061a8abc9d36a13bb7982f9b3398bcd192673944ca4347b34a463"
    sha256 cellar: :any_skip_relocation, ventura:        "5157968c9afb6ca711dd8da0dd80f50172077497362aa21a55e57e96dfaa8ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "5157968c9afb6ca711dd8da0dd80f50172077497362aa21a55e57e96dfaa8ba8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5157968c9afb6ca711dd8da0dd80f50172077497362aa21a55e57e96dfaa8ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6647417ef2b508e185db8a0aac2bb5a26583ae265c30aba185e23a33f4a8cb"
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