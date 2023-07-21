class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.1",
      revision: "4fd630157703590e677728d20348ac6a2dfd9151"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acdcbfcc329a536ad2e8d3d9aefefb6dba730c4331d7ff758ee760e1cb0ae50e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acdcbfcc329a536ad2e8d3d9aefefb6dba730c4331d7ff758ee760e1cb0ae50e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acdcbfcc329a536ad2e8d3d9aefefb6dba730c4331d7ff758ee760e1cb0ae50e"
    sha256 cellar: :any_skip_relocation, ventura:        "1645fbcdaae04eb0a4a32c005a6a95537377cb4eb2032a15e47a9d9f1311d488"
    sha256 cellar: :any_skip_relocation, monterey:       "1645fbcdaae04eb0a4a32c005a6a95537377cb4eb2032a15e47a9d9f1311d488"
    sha256 cellar: :any_skip_relocation, big_sur:        "1645fbcdaae04eb0a4a32c005a6a95537377cb4eb2032a15e47a9d9f1311d488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2b5f3ea435b7a8c0773ec1d48baf602d9e95ed75cf1ee051d97302a12c4200"
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