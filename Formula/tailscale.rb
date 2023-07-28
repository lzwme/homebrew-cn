class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.46.1",
      revision: "2d3223f557924d408b5d67b80440d6fba264a0fd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eda322fa59b4a6999ea451085fe70fd97e1734ff346caab86750c881a441a9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eda322fa59b4a6999ea451085fe70fd97e1734ff346caab86750c881a441a9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eda322fa59b4a6999ea451085fe70fd97e1734ff346caab86750c881a441a9c"
    sha256 cellar: :any_skip_relocation, ventura:        "eecda957f0eba8004cddc456a4063ea9bb1ee2343d54411d523a336e28191f02"
    sha256 cellar: :any_skip_relocation, monterey:       "eecda957f0eba8004cddc456a4063ea9bb1ee2343d54411d523a336e28191f02"
    sha256 cellar: :any_skip_relocation, big_sur:        "eecda957f0eba8004cddc456a4063ea9bb1ee2343d54411d523a336e28191f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9662eaea5875927123635e3fbc24242785f8af42868d1ff0e5d2887544294b"
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