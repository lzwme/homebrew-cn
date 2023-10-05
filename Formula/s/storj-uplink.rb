class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.89.3.tar.gz"
  sha256 "be798fd2b12ceaa8d397f093e653a40c1b13535d88d05467e99a7b65cf704bff"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e540fd36de1764ac31dcf41702abd5987b435cca89c07f876b3713b42abaec25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b28d6bc93df8118a4cf65343184cdbcf00c809d9f8169ee13651c4dd4070d257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a85352962f7ae48c9e6cd18cc106d25f87d569d438f02aeeb2e0b970850bb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "378707f7913672256a836a51a5326702279ae722c5a9b02d3c64bcb595ab1642"
    sha256 cellar: :any_skip_relocation, ventura:        "8d14ffbca9aa883d484b2e6571b5bf7f61b10b2b7d6bc0fdf7ca0ce38732b8cb"
    sha256 cellar: :any_skip_relocation, monterey:       "042635fb4034ff024a696b3a0c3b123593642f4d060436a6a8a3af1794ae4333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b7f50a172325f61c4ad8d72f98d861116c9e31963ff9aeb9d6822b8c8708b7"
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