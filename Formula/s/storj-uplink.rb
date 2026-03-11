class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.149.2.tar.gz"
  sha256 "fe2e8829253d22e1a925374490c0690d24c3e2eb696f3709ca6a98c44e9d1352"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d14cdf315d7b7d57ce3561a7af3c5b98e569619263db2589b14f54121e899b24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14cdf315d7b7d57ce3561a7af3c5b98e569619263db2589b14f54121e899b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d14cdf315d7b7d57ce3561a7af3c5b98e569619263db2589b14f54121e899b24"
    sha256 cellar: :any_skip_relocation, sonoma:        "36e349ec8828afcc5a5c3ad0aa450b28366c013d8c9486a697c1970af4674d24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc5f9c2ac349eeae907dddf84726f46802d3e212b0585aeb61cc2faa90a6274e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d5e4816fe27dce2db2800c4e7ff853662129b802d76db9dd44fc8e997d09b4"
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