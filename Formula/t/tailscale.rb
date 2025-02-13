class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.80.2",
      revision: "c7a79d7bae40495113f888110857eba411779ef6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b623e72241867ce3f6879a84efd6ee5a2e418d1c5faff14b611f3fed2d77c78c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c22beb008f2bd7c0231390af0a405beab4039342e2ab73df215ff01b766538bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ff8ffbb1e11929233ac8bc24e65b9fb991271028ee17ca8e3d1a12724fe75a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e137c1399cbd188ddf2bda6d9cc5c743ac806e68200929ce79ae6a2c41be8a"
    sha256 cellar: :any_skip_relocation, ventura:       "8fd641bfe9c75e9f607aaf166a607d92383c47e0cb144d1ff74dc1cf7eaa05eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38edbdf50d57c2ec211a95dedf380c4c5d76480dceb334bebd14dbfc11de6139"
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

    generate_completions_from_executable(bin"tailscale", "completion")
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