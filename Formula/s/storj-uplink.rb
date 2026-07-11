class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.158.7.tar.gz"
  sha256 "8c6ef49891f13f37179ca05fde0e03ebc09d712200ec1901650d6f370c4d52ff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64fc4ad990d22a5b29bf3f857d4570b821af99ae20fe78f3a3779f34938f6e18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64fc4ad990d22a5b29bf3f857d4570b821af99ae20fe78f3a3779f34938f6e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64fc4ad990d22a5b29bf3f857d4570b821af99ae20fe78f3a3779f34938f6e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c95dd7bc28e39a29d5f4c70501145592b36a9fa833b15da6f910f9048647969"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d208eb5b359b3e6a38bcbd2a8765a46861a03776357e61ea0f520eb51374bfe4"
    sha256 cellar: :any,                 x86_64_linux:  "7c58dd99f81d0ec300b1e2e515ee4f807092ed2070f8a9f8d1ad921f7b655c74"
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