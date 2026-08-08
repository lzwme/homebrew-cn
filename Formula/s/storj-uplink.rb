class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.7.tar.gz"
  sha256 "33985a7e7b2b3d5f4476d1a45b6085151df062d52b7be9079ed46012bf13e2ab"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0341ce54a93f4b989df09a6457fcc098e17a38f59240d96e7a67ff32d84bde42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0341ce54a93f4b989df09a6457fcc098e17a38f59240d96e7a67ff32d84bde42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0341ce54a93f4b989df09a6457fcc098e17a38f59240d96e7a67ff32d84bde42"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b9cda7e93563d6a0787f3cca95fa91447966d65b942d90b131b9f1006ff1f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dbf93d44a7adc9c3497b5e944f67b5ce8a5f98a1db1c09eba2668d783fcc3ff"
    sha256 cellar: :any,                 x86_64_linux:  "5f1eb6ac74a4e639016395db89c02ee284004b7cf975e0c54eae198094de1c39"
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