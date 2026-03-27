class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.150.2.tar.gz"
  sha256 "8f343fecbcbaadfb4d77eef819160f640808c7400d3331af7b92ce1b7c20d59b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a6ab66ba7d3f0d19d1de347e39da1c63d15959027e51c009c098cf36c02a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a6ab66ba7d3f0d19d1de347e39da1c63d15959027e51c009c098cf36c02a78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a6ab66ba7d3f0d19d1de347e39da1c63d15959027e51c009c098cf36c02a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "21569b25336890b401f927fb9bd7b5681e79b0235404aea7508da19dc60cf6f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0d91060a53f747bebe817bcc772c442995a59b0ce0e7a3c9cc0ece769fff9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "526eb8e1cb716ab5c3f1e256346413c29443b25ef3b9ac4f308559958734a4e0"
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