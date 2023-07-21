class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.82.1.tar.gz"
  sha256 "17e54c5a439313b464dd187abe263d9ec72fd8339397538f6c430388bb501b26"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee34821e8cd21257246e0ca230605e3dcb5f55e0d7536656870092ed9187c4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee34821e8cd21257246e0ca230605e3dcb5f55e0d7536656870092ed9187c4f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee34821e8cd21257246e0ca230605e3dcb5f55e0d7536656870092ed9187c4f6"
    sha256 cellar: :any_skip_relocation, ventura:        "778a854fe11163a4601826b81b69854cdae3ea6a0bd9c405b6c7b6277433cf3c"
    sha256 cellar: :any_skip_relocation, monterey:       "778a854fe11163a4601826b81b69854cdae3ea6a0bd9c405b6c7b6277433cf3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "778a854fe11163a4601826b81b69854cdae3ea6a0bd9c405b6c7b6277433cf3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a5e533c95a973d53bf2e89a427ecf2d37edd8f887a1e3e4bfc41085f8b12eb1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end