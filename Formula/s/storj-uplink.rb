class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.158.4.tar.gz"
  sha256 "6100556f1904db05266d8af460639dc92c1b4e2d3d6d24f893edcdf3e04fbd15"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8b86c6c7e8b59c36a493ac69b2314f0e1827e97cdc309d0f508769eae274370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b86c6c7e8b59c36a493ac69b2314f0e1827e97cdc309d0f508769eae274370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b86c6c7e8b59c36a493ac69b2314f0e1827e97cdc309d0f508769eae274370"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f5a9987b5bad631ed0742470eedc88ff15a2583b7358b35b18c1789541db04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a38f2363199f42ab21ef9d56d277ccc775b0464e86c6e7937df286c6f4331d1"
    sha256 cellar: :any,                 x86_64_linux:  "39eb609c7d9fb41597473b241d86c9d3867337a458c934f2cf2f4328cdce2419"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
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