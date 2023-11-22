class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.91.2.tar.gz"
  sha256 "5c01f289853d62b393a36512bab0e78a6c4b145df4f60abf3ddae5dce42b9650"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c05429afdfb66e0f1b958ccf11ea77e6f8418b74323856134d00aaf2b08ced3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22f75861c14b2ab5afbea293fd71a8fcbaf74d3d4489d73922a4966f3c80dc97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bc13711911e614d35c1508dd972f582c7c29264cb063cc3366d3ae874c6b662"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cc5e1d29b0c7985bcc884dfb7e238b166fb5efe339240a3817a627165a8d919"
    sha256 cellar: :any_skip_relocation, ventura:        "9535d621e3e9158fdc2c130060ad83b872f0453bb213fb91c91713cd136c5d18"
    sha256 cellar: :any_skip_relocation, monterey:       "27e228c2b10d4a64aeb012749e3a2239911b16db79b19d839cef1740485c5514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf23d981109e9096ee4c41ad92561407daf883a2efed291187f01b206f432e5"
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