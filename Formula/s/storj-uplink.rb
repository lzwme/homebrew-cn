class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.146.5.tar.gz"
  sha256 "8e4b36e0ada0cc0237e5898e91c170db821b89d0f1265c75951bd966f86f51be"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ff17002d3c252a7065e9625465a9f61633599858c6b408d5bcd41b686fb3eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff17002d3c252a7065e9625465a9f61633599858c6b408d5bcd41b686fb3eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff17002d3c252a7065e9625465a9f61633599858c6b408d5bcd41b686fb3eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6ad27d0e02443760d1e305a1500060f8882f7a6785b5edf58cc52e837659cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40699f936987541d5e33bfa3911aae268a132e3d38464910fa38b9a3153bfa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de4bf41a5ee1406988faf55b421818ca355e76de938c400af66eb26663c1737"
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