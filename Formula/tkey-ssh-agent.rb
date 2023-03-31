class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://ghproxy.com/https://github.com/tillitis/tillitis-key1-apps/archive/v0.0.6.tar.gz"
  sha256 "d15fc7f556548951989abf6973374f71e039028202e8cad4b70f79539da00aff"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a0f69100ad2a590ba0c7bd419363a0b880af84d616e7e2abcf1d9e30edf6ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9004480a25bc99dd482306381cabab955ecb80c682c1682dadf1895af34851f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de6f9d6277af8d4d590f6657f310cb8eaf96c4911cbbc7dd40e8b5fb9a8c4e89"
    sha256 cellar: :any_skip_relocation, ventura:        "0d63b8dcde16d4976f8fc028bfce9006da7571b0c41ed71b33ad9eac670c6696"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d7982a3e2f51293b85f458387bf7c32943587d9d10427c607c5f6ae47cf5f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "09e8cbdc5c2f618c9c026dbadc32a5a738776199b8652798efe7ebe7c93724aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1af49cacb494a956d3af76497634cd50b09e719999ea5a96f2a5902c95cdee3"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  resource "signerapp" do
    url "https://ghproxy.com/https://github.com/tillitis/tillitis-key1-apps/releases/download/v0.0.6/signer.bin"
    sha256 "639bdba7e61c3e1d551e9c462c7447e4908cf0153edaebc2e6843c9f78e477a6"
  end

  def install
    resource("signerapp").stage("./cmd/tkey-ssh-agent/app.bin")
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tkey-ssh-agent"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
        export SSH_AUTH_SOCK="#{var}/run/tkey-ssh-agent.sock"
    EOS
  end

  service do
    run [opt_bin/"tkey-ssh-agent", "--agent-socket", var/"run/tkey-ssh-agent.sock"]
    keep_alive true
    log_path var/"log/tkey-ssh-agent.log"
    error_log_path var/"log/tkey-ssh-agent.log"
  end

  test do
    socket = testpath/"tkey-ssh-agent.sock"
    fork { exec bin/"tkey-ssh-agent", "--agent-socket", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end