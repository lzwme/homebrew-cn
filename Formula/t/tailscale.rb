class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.86.2",
      revision: "d72494bac7a2fb6b6a01715cfc5bcc903dbd7594"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2304ca5a3cb0b4e472a2b9616e5775419e6834370750cd910aaa11abe6cdbe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e258fa58642c55cc0ba62505675721f5b93de98a11b961cc312659512b9de318"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ee9215408806fde078630b212e3f34d8149babc32d084786cd3cb445930d38a"
    sha256 cellar: :any_skip_relocation, sonoma:        "143d453666942157bf0aa150049a83a6d158cf7cf207a5ded63e9557ebebe14a"
    sha256 cellar: :any_skip_relocation, ventura:       "56fb8b1cb3b3e71841890f6139d26fca45c4da88b3fd573b8bfd1207d115ef2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1e36ea43d3dc4290819bcf22339d2341d4e22fc713590bdd4219bbf22b0540"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale"

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