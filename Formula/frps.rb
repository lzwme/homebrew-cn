class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.0",
      revision: "53626b370ce2be290e844e58a1384af5059ea489"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d88b6b2f2ff5b1c2ce578731b007cc5af6bcc8ca3c17888e4e508ae0b8bf8be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d88b6b2f2ff5b1c2ce578731b007cc5af6bcc8ca3c17888e4e508ae0b8bf8be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d88b6b2f2ff5b1c2ce578731b007cc5af6bcc8ca3c17888e4e508ae0b8bf8be"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa09c7f1f5941704c32335a60e2dbccfcc72ba4f4b2367af6c57a702930817f"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa09c7f1f5941704c32335a60e2dbccfcc72ba4f4b2367af6c57a702930817f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aa09c7f1f5941704c32335a60e2dbccfcc72ba4f4b2367af6c57a702930817f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c30e9c4a716ce2b6d59c0f709fe616121ca9fd54b3798ad3530216153f910c"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end