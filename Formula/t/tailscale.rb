class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.58.2",
      revision: "b0e1bbb62ef3834e99f5212b44043cec1866b07e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a49ab98a19705246ec62c173bbf17186df2520f49e563697e4e3eb9ac14a70f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07ae6fea39024f2fe39899652ad5db472d4f40511e7b78128ee8150b5838343a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a680f8d7993a2556c134938034f915e4e5b40f8c774d1e0d33ec808298e2b437"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdb31085c53afc854c3f24fb982ad4b5b16f1ab1c86636faef6d3d7ab5e19ee0"
    sha256 cellar: :any_skip_relocation, ventura:        "41dc8a5977761b6aad8f02bf62d3b9b14b33c3219a5721552d6d866265dda449"
    sha256 cellar: :any_skip_relocation, monterey:       "44f64d658dde7d17bc5b4c74e694011ac1824da0cb858fc798df23b5ecd88b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "effc250a7aaa97031982d3521b6e0b1bac779d235241eeb50c9f0ae007439105"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"tailscaled"), ".cmdtailscaled"
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