class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.158.8.tar.gz"
  sha256 "e86a07582fbd286d815da47e64f378681834fd358721ad865db098a1e8447d6f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bc9fa3db24cdf681e818069866de180cee6c33d865f2f27812d0827b40f4126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc9fa3db24cdf681e818069866de180cee6c33d865f2f27812d0827b40f4126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc9fa3db24cdf681e818069866de180cee6c33d865f2f27812d0827b40f4126"
    sha256 cellar: :any_skip_relocation, sonoma:        "303d4a025fbb0621503415c62c4ebcdeb23d24a713dd4064190bfe0adcc7d8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f60b1aeb2cd487635b475e92ff2b4c3352769394b400c6f15f0ec912945d47"
    sha256 cellar: :any,                 x86_64_linux:  "927dfe0e5752fa205e06099825861caa2edbee1a376efce773f20e64ba5b93b2"
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