class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.66.4",
      revision: "e64efe4f777cb5b4d9efd603ad1360a509006cd1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51df178e46bc274062aba844825ed24d9aaa8b1497c723fbe57a65e3a009a8be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fcc3bdfdef7c917752f6b2db5baa4f8f79a73fe8e15b6f7469df5c0a144cac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e47c155e90c72570aa421fa6199e1ef7648386afdb874938b75e9b9471e097"
    sha256 cellar: :any_skip_relocation, sonoma:         "72b5345ee941c24994313ea4fa40dce1263c730720419a0d55c1fbb2f9991327"
    sha256 cellar: :any_skip_relocation, ventura:        "7c1bbaeacc5e396ba5f843f73f765d49e0a8ef04fd93f8073fd23598e3b9257d"
    sha256 cellar: :any_skip_relocation, monterey:       "f3317b2ee143cd147751af31b8bc25b12c973d3de966f6001045dcb1f2eef05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9da6975b2475010a279250b42a28e6408b92b0ab7c2b7b70165b92e1276e346"
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