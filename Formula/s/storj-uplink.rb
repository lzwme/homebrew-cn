class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.8.tar.gz"
  sha256 "37626f2cbb856e6d797debebdf494011fcf3bb08b0753371f5c81088fdf33303"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa028fda9c28d76abdc236c86ed4acc45e2f8e08eeff3e7a784e3bcc98ca560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa028fda9c28d76abdc236c86ed4acc45e2f8e08eeff3e7a784e3bcc98ca560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa028fda9c28d76abdc236c86ed4acc45e2f8e08eeff3e7a784e3bcc98ca560"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c46a15c02d5e33c7f76a483df94a488bbd644c6efde94b868ec141b0313d76d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b155c9e129b37dabd8c13a16205b1495e5ec6e8191b7b7b6577aa9eeb6758dc"
    sha256 cellar: :any,                 x86_64_linux:  "bf096e245910555c0e91dca6470a1eba8021e4f62093952be6d77e74b93ad12f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end