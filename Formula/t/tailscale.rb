class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.52.0",
      revision: "31e1690f38c5de5ebe25d7735d368bbe9c7d2f28"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1d348b8026b518a53be2dcfe1eba9db4411b5758f21aabb055423f234b9fe89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb55298ea5c63348b326c55574e36efa5cd1bec0a28897105b1bd7e855e2199f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7383bb7c3ffc523934544bca148c0ed49a39f4c554e8035c1710c76de5b4dc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e380c37fa65e7d443663b092843ba6410ff132c43bbf110c5ce34c6578f102b"
    sha256 cellar: :any_skip_relocation, ventura:        "e444b63d4062ab0e01e9f3adae59f5b80cd2ad308359aac449f9c62dcc477ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "07b856fb5c38677b370790b72822591a4a1d9fc08650e7d36a7e217865b77763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31e0ee145e9b82bbd917e998ba735634ccc6eec150affbb7c5f88703b377329"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tailscaled"), "./cmd/tailscaled"
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end