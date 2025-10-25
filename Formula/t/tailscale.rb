class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.2",
      revision: "8bcd44ecf07ba1ba8134526b6ed39b9e9e880b7b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3fda43d0d35d8e88c2aaea94a183ea16b45e0173e1884c1d4dde38395531739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6e0dcfe1d35c5fb298afd02886b019dd6bf83328e4d6dfb137fc810e94d4c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd721f7826b2e700a214ebcce5ce9f7fa69aa3dc6581a3d77ed605b596fbac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e94ad3f8bf705888e9f4fd99453b0934fa5807c9ae872ee2d2b7d7bb0d5ef697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a5fd26e192dd48dfd72106f813e4eadc28422d08a9d51f31454873e03747ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0909153202da68f8082d8b96f311f70beac279a5ab9c44b4296be1818a02a9"
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