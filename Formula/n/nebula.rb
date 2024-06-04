class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https:github.comslackhqnebula"
  url "https:github.comslackhqnebulaarchiverefstagsv1.9.2.tar.gz"
  sha256 "8eae7e8158657d2ccabef24e4ddaf04e1903b5435c699b49f2cc63a21239a777"
  license "MIT"
  head "https:github.comslackhqnebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7eb46e0e1bdc7fbb531acf7175f5bf335a621db4fc54cb2d819b1dab5d788bb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eb46e0e1bdc7fbb531acf7175f5bf335a621db4fc54cb2d819b1dab5d788bb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eb46e0e1bdc7fbb531acf7175f5bf335a621db4fc54cb2d819b1dab5d788bb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "988fe8b53b964847155e3b44120a5d277db84695fbae7bdc22709d3aa60780d0"
    sha256 cellar: :any_skip_relocation, ventura:        "988fe8b53b964847155e3b44120a5d277db84695fbae7bdc22709d3aa60780d0"
    sha256 cellar: :any_skip_relocation, monterey:       "988fe8b53b964847155e3b44120a5d277db84695fbae7bdc22709d3aa60780d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "363a195cdddd42e48b23142b02168ac050c3cfc77a9a9bb1b763ae43dba0f294"
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