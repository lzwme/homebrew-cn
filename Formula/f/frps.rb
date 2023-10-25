class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.3",
      revision: "44985f574dd3924e9cb48a969fddbd72b3afe2b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "401c520380c665c09b5f99283a27d16b0e94c39b1134013a584c07687263c054"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "401c520380c665c09b5f99283a27d16b0e94c39b1134013a584c07687263c054"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401c520380c665c09b5f99283a27d16b0e94c39b1134013a584c07687263c054"
    sha256 cellar: :any_skip_relocation, sonoma:         "db96cd98bcd2a8b9f6581c179cbe834eccf693ab6512aeb8f6439bcecc99f5bb"
    sha256 cellar: :any_skip_relocation, ventura:        "db96cd98bcd2a8b9f6581c179cbe834eccf693ab6512aeb8f6439bcecc99f5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "db96cd98bcd2a8b9f6581c179cbe834eccf693ab6512aeb8f6439bcecc99f5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0014c3dc5facb8257d2a67fa0e991e2a626e38d08bf3c0abfc2aae8ade9ed13b"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.toml" => "frp/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
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