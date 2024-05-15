class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.66.3",
      revision: "eae73f821381ce653468ba3c4eec3453c0808953"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b0e9e56594d7112bf1ce6842fc128a8fb587fac66d2b46ea13acb9ab01714ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1631ab02e3d08022d7e475c74e01d863dea461a6cf08493871adddc6f0673ddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f14298a8343a09ad43ba63e229e46cfc20a14c15d176fc629b3c18ff412f789"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e0a58bd6706826715c16e9bfe05591bb0c1a2a3e97a3d7ab3e536cb9bfa6c85"
    sha256 cellar: :any_skip_relocation, ventura:        "83303822622768c25dc0c273ee112821f1a17436890757c6fee0a4157d233567"
    sha256 cellar: :any_skip_relocation, monterey:       "ff93b8a467d58814bea2d16c9a1d9e7fbd77b4b7da827c22015c0fc78af87e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc09f4f697b888c7fe768c67cead9c6a519bc1517ffc5cf1f0b8af1170af397"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read(".build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.comversion.longStamp=#{vars.match(VERSION_LONG="(.*)")[1]}
      -X tailscale.comversion.shortStamp=#{vars.match(VERSION_SHORT="(.*)")[1]}
      -X tailscale.comversion.gitCommitStamp=#{vars.match(VERSION_GIT_HASH="(.*)")[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin"tailscaled"), ".cmdtailscaled"
  end

  service do
    run opt_bin"tailscaled"
    keep_alive true
    log_path var"logtailscaled.log"
    error_log_path var"logtailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}tailscale version")
    assert_match version.to_s, version_text
    assert_match(commit: [a-f0-9]{40}, version_text)

    fork do
      system bin"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}tailscale --socket=#{testpath}tailscaled.socket status", 1)
  end
end