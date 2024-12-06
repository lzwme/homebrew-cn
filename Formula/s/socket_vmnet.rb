class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https:github.comlima-vmsocket_vmnet"
  url "https:github.comlima-vmsocket_vmnetarchiverefstagsv1.2.0.tar.gz"
  sha256 "f2e2b1fc10c9c72f3a707653f79543b11a37ec91987ae2a6d0327a41271974b5"
  license "Apache-2.0"
  head "https:github.comlima-vmsocket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccaaccb9445d52493a5efc463978b4fe0adcb3eab1eb9702c90512ac3b8b858b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2906a977ff8ecf65a562416eddb822f4c110d46757c33df263d1a5a2fa70570a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff41070db80e2ee4a098c8039b2c12b425d38471777348c253c5ee67b1857d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c4b5acd19c8e2d70b929824969ed7a104fbca474601a2f3487a721a1df51e4"
    sha256 cellar: :any_skip_relocation, ventura:       "94a81b343fcc04395fd5a862f9ba13c399286c436b6f90e70ad2086262fb1596"
  end

  keg_only "Homebrew's bin directory is often writable by a non-admin user"

  depends_on :macos
  depends_on macos: :catalina

  def install
    # make: skip "install.launchd"
    system "make", "install.bin", "install.doc", "VERSION=#{version}", "PREFIX=#{prefix}"
  end

  def post_install
    (var"run").mkpath
    (var"logsocket_vmnet").mkpath
  end

  def caveats
    <<~EOS
      socket_vmnet requires root privileges so you will need to run
        `sudo #{opt_prefix}socket_vmnet` or `sudo brew services start socket_vmnet`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  service do
    run [opt_bin"socket_vmnet", "--vmnet-gateway=192.168.105.1", var"runsocket_vmnet"]
    run_type :immediate
    error_log_path var"logsocket_vmnetstderr"
    log_path var"logsocket_vmnetstdout"
    require_root true
  end

  test do
    assert_match "bind: Address already in use", shell_output("#{opt_bin}socket_vmnet devnull 2>&1", 139)
  end
end