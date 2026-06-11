class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.155.7.tar.gz"
  sha256 "63008364fc233071fd07b2b5d6ea0161029e6f49f26d819d37d991d16128a0bd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7b22c2bcaec68691eeff21aea16f71df634fc21cf1d6cca977e01ab7bab9af2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b22c2bcaec68691eeff21aea16f71df634fc21cf1d6cca977e01ab7bab9af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b22c2bcaec68691eeff21aea16f71df634fc21cf1d6cca977e01ab7bab9af2"
    sha256 cellar: :any_skip_relocation, sonoma:        "029ae3e157af5da1122aea4679b95ecc7ddd9659a754fc403dbcc78e13e7a2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b07ee5ae32b911d588c3fdb9e46b0eec301c2cd9c97dd207cc2ef47ab339e63e"
    sha256 cellar: :any,                 x86_64_linux:  "7e006e186b7b9a382057285fe607b115b9660ff945fe030d722cb21c8027634e"
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