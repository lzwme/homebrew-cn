class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.46.0",
      revision: "49cb73432a2d909f0c842f9e8fd38253baa062a5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3828d31f595515dfe1379bb3152c7e93335de2f46c6439496816d6b6a13f1a0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3828d31f595515dfe1379bb3152c7e93335de2f46c6439496816d6b6a13f1a0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3828d31f595515dfe1379bb3152c7e93335de2f46c6439496816d6b6a13f1a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "43458b718cf6cd3cb186d9d8b0785acbf47980bf9837d626a79c2c2d12928418"
    sha256 cellar: :any_skip_relocation, monterey:       "43458b718cf6cd3cb186d9d8b0785acbf47980bf9837d626a79c2c2d12928418"
    sha256 cellar: :any_skip_relocation, big_sur:        "43458b718cf6cd3cb186d9d8b0785acbf47980bf9837d626a79c2c2d12928418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69169388f0413e864bc30ebb238bf1c81d2c7a146cf9f9e90bca1ace36f4c122"
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