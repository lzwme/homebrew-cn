class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.139.6.tar.gz"
  sha256 "af8065e541bf495c03e9254b1db5e22c89d737b8d37639745e8122a090129957"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36209c2ccf9763ea452cd05e9cabdb87bcedf54fca3005f81bfc15527c77e327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36209c2ccf9763ea452cd05e9cabdb87bcedf54fca3005f81bfc15527c77e327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36209c2ccf9763ea452cd05e9cabdb87bcedf54fca3005f81bfc15527c77e327"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f71f2cd8156954f930a8332280d2aef23492ea7d39c1974bc40bdebb67801a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c6acd0c26b92b1afc6ac6c7429e01eeedaac1199d24efae9d5b69d88a113b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0366cf74469e5a782f33da15c394ff9b580f874e4500799b5e070b9c9ed5c53d"
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