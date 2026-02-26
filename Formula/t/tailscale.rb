class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.94.2",
      revision: "2de4d317a8c2595904f1563ebd98fdcf843da275"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "108283741824bec70d11ae348f0af09e3cba7d84dd16a5cacedb15c5f69bc60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c5506d7a5f909cfb94fac1cce1628c6916fa2f01cefc2825cd088763931090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96b7887c1fbbb55c58d9a1efb4f9205d3277c226ea9edced21230da5281417b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b49997ee1f475d64e625193c3dc84710e8d623222dd52e52592ca7cee135f8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c386390d1a723d0e096f3246d617f85eaac061907e209743b301e8c7750cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "febd25594fc848792f30d935077b801509fb13306d50b1db410994229c4f07e8"
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

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
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

    spawn bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end