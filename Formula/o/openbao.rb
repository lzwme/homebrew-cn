class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.4.0",
      revision: "f9407a27fbee45f62ba521bba2bf1e2360c61031"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da8fd4c5e9696c16b6836bae0ac0f6ca00087e76515a63803aafbde0eaf4e44e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206122b0487ea4eb772f864c2d196b2c4336a9ede68a339274722f98b2456e44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b88610cf222ad7eba6be004be9ffb2498ee5fd917f5b6e79ebf68fb8ee41982"
    sha256 cellar: :any_skip_relocation, sonoma:        "27231347e92a10259aab7dd55491c88f86326d5ea880a5091c01a06048a3c8cf"
    sha256 cellar: :any_skip_relocation, ventura:       "9f21898b94d16c27527c8751eb5e1edd824a6c4f77a45756f19e47babfee80eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b82a76916f9152d8e7544cb5a61bb287bf66c2742909a7f211d0bc6d94c1679a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47764a8c90fe720e3531d5b8a8841db5d380c018aafe9a30262d334c3818cc9"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node@22"].opt_libexec/"bin" # for npm
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/bao"
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end