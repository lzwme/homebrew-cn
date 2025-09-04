class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.136.4.tar.gz"
  sha256 "924cf2d5402322a8318a5373643a28887285ae51bacf455cd33a351b0d56edd8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690171b9ff3329cdbf25e4ac618c592df3eae7972b705c14f8a11030d28fe0e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "690171b9ff3329cdbf25e4ac618c592df3eae7972b705c14f8a11030d28fe0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "690171b9ff3329cdbf25e4ac618c592df3eae7972b705c14f8a11030d28fe0e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "86d5ab80a6534e48b4166b7cd95a8d193600b9397dadfbb9ba0f4015278775f5"
    sha256 cellar: :any_skip_relocation, ventura:       "86d5ab80a6534e48b4166b7cd95a8d193600b9397dadfbb9ba0f4015278775f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d4bfcc18b9d9d5173c1871cff4b1394299e37bb6c2106a8c912a7b7848194c9"
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