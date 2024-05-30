class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https:github.comslackhqnebula"
  url "https:github.comslackhqnebulaarchiverefstagsv1.9.1.tar.gz"
  sha256 "c4dc2138d67cd25925ebb788e6013cbb0cd6c94e84e76eeddea4dea1ddd22e86"
  license "MIT"
  head "https:github.comslackhqnebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ace38b12470fc147c0623f60d47c2ea3b3e52dbb44156d484bf00220304ba3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ace38b12470fc147c0623f60d47c2ea3b3e52dbb44156d484bf00220304ba3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ace38b12470fc147c0623f60d47c2ea3b3e52dbb44156d484bf00220304ba3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e83a29d50ac4901dd9b38f438b53192efd5cf88483e40dcab6fd9887b21fa95e"
    sha256 cellar: :any_skip_relocation, ventura:        "e83a29d50ac4901dd9b38f438b53192efd5cf88483e40dcab6fd9887b21fa95e"
    sha256 cellar: :any_skip_relocation, monterey:       "e83a29d50ac4901dd9b38f438b53192efd5cf88483e40dcab6fd9887b21fa95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "420e5c399c9c8c22293890f292f72fc5af50f5080f96c6731cc610e95c0df586"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install ".nebula"
    bin.install ".nebula-cert"
    prefix.install_metafiles
  end

  service do
    run [opt_bin"nebula", "-config", etc"nebulaconfig.yml"]
    keep_alive true
    require_root true
    log_path var"lognebula.log"
    error_log_path var"lognebula.log"
  end

  test do
    system "#{bin}nebula-cert", "ca", "-name", "testorg"
    system "#{bin}nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.124"
    (testpath"config.yml").write <<~EOS
      pki:
        ca: #{testpath}ca.crt
        cert: #{testpath}host.crt
        key: #{testpath}host.key
    EOS
    system "#{bin}nebula", "-test", "-config", "config.yml"
  end
end