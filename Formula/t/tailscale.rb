class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.54.1",
      revision: "b78b2457040a63fa532e729afed2e4f7deccf39d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5230d1b9b2a1fec01a2c072a6d047fce5420829f68cb9cd0b50d08783406d58c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36caa3782459e345267ac7c018b1c4a1c5163887d2a134ff07118591236287dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01a0d63861e2e2563fafd59c935a93524c0a1c82c90fb4a2a02ad52f0ef3145"
    sha256 cellar: :any_skip_relocation, sonoma:         "e03ebfd642b3d9fbf60807afdc5ac98fb8fea7cc09581e336f2edc90fa3c5887"
    sha256 cellar: :any_skip_relocation, ventura:        "90851c928d081d102e3a5a6eb6f7fa487c5f4805d0e95c200e8de20b541a3f89"
    sha256 cellar: :any_skip_relocation, monterey:       "1519c9afb032ff3fb4f0049eb7425b35e98363e2b199cea420e5efe1f04cba98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044eb42b9459f5a352a40d8658b567c7b6bff063d360c0201b48e1dfc9ec1e6b"
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