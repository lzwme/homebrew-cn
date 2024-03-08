class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https:tillitis.se"
  url "https:github.comtillitistkey-ssh-agentarchiverefstagsv0.0.6.tar.gz"
  sha256 "b0ace3e21b9fc739a05c0049131f7386efa766936576d56c206d3abd0caed668"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1693eb4c1246a0d6afd2dd24902f34cf8e8f92e3009c0b95325e29f1e576e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79f70b9d9de1d77985992cb64e3a455e6863a7a2a0697b1295a31bada78b544d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0c368897a67c585ec79ccef5e95940637a8bbcf47db37037b6f29f652606f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f62ea8147b984c3efb65831704ab4c8de14c65622ad5fb94ee3aeebfc561fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef52e8c902faaa44b64409de0baea593a7ac1075ab179308cf926109deba6b7"
    sha256 cellar: :any_skip_relocation, monterey:       "60d5a0a4f086a93f1c994209604cfa2a4e4b304b6e6b8025f5d1561551009c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6330e99e8ada1967925e768f19ab93405c445a18876baddd43d8d8cd9d91a3c0"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  resource "signerapp" do
    url "https:github.comtillitistillitis-key1-appsreleasesdownloadv0.0.6signer.bin"
    sha256 "639bdba7e61c3e1d551e9c462c7447e4908cf0153edaebc2e6843c9f78e477a6"
  end

  # patch `go.bug.stserial` to v1.6.2 to fix `cannot define new methods on non-local type C.CFTypeRef` error
  patch :DATA

  def install
    resource("signerapp").stage(".cmdtkey-ssh-agentapp.bin")
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtkey-ssh-agent"
    man1.install "systemtkey-ssh-agent.1"
  end

  def post_install
    (var"run").mkpath
    (var"log").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~.zshrc andor ~.bashrc:
        export SSH_AUTH_SOCK="#{var}runtkey-ssh-agent.sock"
    EOS
  end

  service do
    run macos: [
          opt_bin"tkey-ssh-agent",
          "--agent-socket",
          var"runtkey-ssh-agent.sock",
          "--uss",
          "--pinentry",
          HOMEBREW_PREFIX"binpinentry-mac",
        ],
        linux: [
          opt_bin"tkey-ssh-agent",
          "--agent-socket",
          var"runtkey-ssh-agent.sock",
          "--uss",
        ]
    keep_alive true
    log_path var"logtkey-ssh-agent.log"
    error_log_path var"logtkey-ssh-agent.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tkey-ssh-agent --version")
    socket = testpath"tkey-ssh-agent.sock"
    fork { exec bin"tkey-ssh-agent", "--agent-socket", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end

__END__
diff --git ago.mod bgo.mod
index aaf7fbd..22b4ff6 100644
--- ago.mod
+++ bgo.mod
@@ -6,7 +6,7 @@ require (
 	github.comgen2brainbeeep v0.0.0-20220909211152-5a9ec94374f6
 	github.comspf13pflag v1.0.5
 	github.comtwpaynego-pinentry-minimal v0.0.0-20220113210447-2a5dc4396c2a
-	go.bug.stserial v1.5.0
+	go.bug.stserial v1.6.2
 	golang.orgxcrypto v0.5.0
 	golang.orgxterm v0.4.0
 )
diff --git ago.sum bgo.sum
index f0652fe..805352e 100644
--- ago.sum
+++ bgo.sum
@@ -26,6 +26,8 @@ github.comtwpaynego-pinentry-minimal v0.0.0-20220113210447-2a5dc4396c2a h1:a1b
 github.comtwpaynego-pinentry-minimal v0.0.0-20220113210447-2a5dc4396c2ago.mod h1:ARJJXqNuaxVS84jX6ST52hQh0TtuQZWABhTe95a6BI4=
 go.bug.stserial v1.5.0 h1:ThuUkHpOEmCVXxGEfpoExjQCS2WBVV4ZcUKVYInM9T4=
 go.bug.stserial v1.5.0go.mod h1:UABfsluHAiaNI+La2iESysd9Vetq7VRdpxvjx7CmmOE=
+go.bug.stserial v1.6.2 h1:kn9LRX3sdm+WxWKufMlIRndwGfPWsH19lCWXQCasq8=
+go.bug.stserial v1.6.2go.mod h1:UABfsluHAiaNI+La2iESysd9Vetq7VRdpxvjx7CmmOE=
 golang.orgxcrypto v0.5.0 h1:U0M97KRkSFvyD3FSmdP5W5swImpNgleEHFhOsQPE=
 golang.orgxcrypto v0.5.0go.mod h1:NKOQwhpMQP3MwtdjgLlYHnH9ebylxKWv3e0fK+mkQU=
 golang.orgxsys v0.0.0-20220319134239-a9b59b0215f8go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=