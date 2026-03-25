class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.150.1.tar.gz"
  sha256 "dd5af5370676f88cff25b73288ace9a48d4d87a7e7dc3827685d66a43a87e6a9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c664239f6decd7f6c89ae313ec496c95596d75daec51d52b6caec2439c365d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c664239f6decd7f6c89ae313ec496c95596d75daec51d52b6caec2439c365d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c664239f6decd7f6c89ae313ec496c95596d75daec51d52b6caec2439c365d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c6d40e12a5bd77713c72c6a533d839101d47210c3ad3597724948634d3b44e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5afe5db4bfabacdf55907219db75c7b051dfbde17effa5b02677da3b90f2d147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e71d1e6e7fc7db12cf62f772c4be5095712c6a4d14762202ec4c9702e0fdf15"
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