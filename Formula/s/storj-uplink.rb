class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.148.4.tar.gz"
  sha256 "79ebd7b5b73247a408e118c6cb41cc0be154e824277f81308de8faba14cc182d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fbc6a87c7f4de9134edde08343ec2b5c416dedffd3ac61e8d869fcb1e7058fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fbc6a87c7f4de9134edde08343ec2b5c416dedffd3ac61e8d869fcb1e7058fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fbc6a87c7f4de9134edde08343ec2b5c416dedffd3ac61e8d869fcb1e7058fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b40aba851efe986e0911407a5d74f031eae45cbe088eb84224f12f0f59560d17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a42888908a4c1c19d0a3a81ad298d5ca90abdd7c65017b691148f7030e5975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81540fc090fa9c6bc5b670fcfce2a59bb4cdc00ab1bba4ed74799058b1f3d3b3"
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