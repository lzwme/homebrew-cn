class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.92.2",
      revision: "95a957cdd7b5c054289345c04ac271128c84c622"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5350bbb903d919d00d5100e26b98265e98872577410c2fcf2153db9378e38311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b9a058189ecd3793efb6bfda4a66c09ef75cff948d708a202b7a8e3baeae140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71c0db425a4514d0de061c2b172909cfd68643d3e42777d7eb4b8b68818548d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8bac1888aec0afc8ec6e2c47b70ce5c0b7d21eba3cf1e2f077b11b30316eb40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3762c82d633faf270c2302bcd1e3347daefc619db01c4f49a2ba72253fd03695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f51d67e562cb4cfdbf088c758d7ad013a7c2caab53f065c59f6d6f4a84b442"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
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