class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.80.1",
      revision: "b9dc617dda124e4fd7bf356c53da074f1dbb2d93"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93013351b567c9ade3b650bfc3c5a98ee4fbd221cf3bacff3e889c6d05bdc504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8c83f55862f5d3bdb58793fd1fc6b4f34fa1bbd7c2891e4a67d7b62375d9c4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf7e18b72813a88aa01fb4ac3813b3765e27659a082b38e2d82925f965ebb08d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f6096f78f37af2739e3cd95381bf09e17a4530553d902d1ad1ea40356a06907"
    sha256 cellar: :any_skip_relocation, ventura:       "f70b7ea1b9584ac7254c0b182c2766c2a59189844021e9702148b5bcca8d08bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459336a1b550bd30457bb61733ae1d876a9d2d214d178d6af796378f9dae7f28"
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