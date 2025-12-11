class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.143.4.tar.gz"
  sha256 "d9e69a5c2a200d90780ec8acd6938d3f169118304d4d89913f49560117687b3a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ca2f3302eb9b939d3419ba81c289dcd425acb8ad3615783c1392b91c2403836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ca2f3302eb9b939d3419ba81c289dcd425acb8ad3615783c1392b91c2403836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca2f3302eb9b939d3419ba81c289dcd425acb8ad3615783c1392b91c2403836"
    sha256 cellar: :any_skip_relocation, sonoma:        "6284b3f67a46de3eff969f709125035e354b8007a76b5062dab53545658a811f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555a0b181ff91b502f2a279a46f2bea03c57660aa96f0a6731cb709385ca883d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e84ab9ed00c0fd3db992f227809a51eb36c23d68b02cd5584e22e024231f5287"
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