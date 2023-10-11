class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.0",
      revision: "2d3af8a108518b7a9540592735274b34d7031bf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9307ae6601ac76e83b1cb2f9982a1b624540aa1a02df95bb25ea512bcce5d6bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9307ae6601ac76e83b1cb2f9982a1b624540aa1a02df95bb25ea512bcce5d6bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9307ae6601ac76e83b1cb2f9982a1b624540aa1a02df95bb25ea512bcce5d6bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa24271b48228a931538eb496a88e744803b7bdc3ebb21b446b58d0efea39d12"
    sha256 cellar: :any_skip_relocation, ventura:        "aa24271b48228a931538eb496a88e744803b7bdc3ebb21b446b58d0efea39d12"
    sha256 cellar: :any_skip_relocation, monterey:       "aa24271b48228a931538eb496a88e744803b7bdc3ebb21b446b58d0efea39d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22754aeb96dbdea30b7b548a64b276d4e51906503ca18328c4a2dd709c2d2be4"
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