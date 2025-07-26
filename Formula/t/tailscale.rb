class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.86.0",
      revision: "758dfe72035fcb2ce00e6ea7693e6f1a11eb135c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6384e19b02b17c26e31b5b97c71e1c2311f59a2623a6438d4879582d966b19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a3911c5411e4363fd5787a13e7fa3a2671b7433f22fbd87627372640b4e7ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4748bd95420de8efaae479b572f89747d5bd1a9882c0035ce5a9f6a6e235f152"
    sha256 cellar: :any_skip_relocation, sonoma:        "5756ecc442b8a14dbac3d73485c4d41744e97639d5e206624bd9b349a7ab0a4e"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b3b233830b8119fbf7edf2a66811ead1fe59b42d2a553b6fe0ec462ac66ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14edccf1ce38370bb56e9abd34397a564bc36042806bb6977bbb17b20dda506a"
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