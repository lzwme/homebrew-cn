class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.90.2.tar.gz"
  sha256 "b92890d55b7a9bbbf90de154b7379bdbcaf619a9ad796fd562db9ac6bee3b228"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f195104a3e634201d51af5052f856a67e1a958cb4f96b7e7f1330430e6b41104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd9280a6c765fa00a8d437e45ea3ca7c001f25cf8f1416a6a642bf17a184f7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae4e76740db55128b0c71d13b5efd9307c0405b1bf7f7efe48b0398f2b02f1ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c49d6a3d761a54b9812ece38875ce1057c3be88cd94240444964d498a661683"
    sha256 cellar: :any_skip_relocation, ventura:        "598691fa6417afa813459e532347d4548058df320a0b5ddd0ee1832c8cea4e36"
    sha256 cellar: :any_skip_relocation, monterey:       "023050ef8fd692ddd88b19d2dfe4a999016d28faf7b24e688dacaa2bba00cbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec81ef5d31e888688322d501602cffa3a78185476c4b088ace77f93c7b5fa11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end