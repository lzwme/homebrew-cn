class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.54.0",
      revision: "c82fd1256bec9ff55e447a64d9054b9f79b4e1de"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fae633cc91d2bb3f526e358ff2afb7aae18adbbba3ba3be21dc2a5a3833a21ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b8d6c70f29e9b9dc507a37a6dc6b8c14522fd51e95900c447b5078eae4d2a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d16dc287ef67256a05b490cb7ac5f0b9346d5b93fdb1ee797385b4635113d655"
    sha256 cellar: :any_skip_relocation, sonoma:         "054f820a1418020c4530f6aa3f1349ec84dce0c16edb5d72025f6a44199d3ece"
    sha256 cellar: :any_skip_relocation, ventura:        "629019ffa66f3221a0eb7370b1d7d6893dc1c523da253331ebfc1b2614c95169"
    sha256 cellar: :any_skip_relocation, monterey:       "8d917c5aa9c4a7da77f926f32b91338eceaddc9dcd3e209fff137ce9b3303c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3959f3dce4483938cb56389ffd837454ba366dd650f837f41184695dd201d87b"
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