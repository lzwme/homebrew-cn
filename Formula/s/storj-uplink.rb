class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.165.5.tar.gz"
  sha256 "55a8b22c0c8d2add263f917f205b81bcc833448e88daf29ed0adce5b82c98503"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2299f0d52e3329b53d99c1c83bf950a808856a857450edfeea8d23e852b4712b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2299f0d52e3329b53d99c1c83bf950a808856a857450edfeea8d23e852b4712b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2299f0d52e3329b53d99c1c83bf950a808856a857450edfeea8d23e852b4712b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b32730d49f2152a6961fbd5002a8d266bf96b6defbf7a201648e9b7339cd1d5"
    sha256 cellar: :any,                 x86_64_linux:      "160150a9cf8549798a0bcb9112ec09da762f7e37e6e9d02539f8b663bbae3074"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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