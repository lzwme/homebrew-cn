class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.150.3.tar.gz"
  sha256 "56423374f6c9a8835a8dfadd6d45b57e5241ed6215447ef0079d22faeabe965f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab21c5cfc823fcb777121ea583d1a9e99334bfae3f421faa6e10fc7a1f77d66d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab21c5cfc823fcb777121ea583d1a9e99334bfae3f421faa6e10fc7a1f77d66d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab21c5cfc823fcb777121ea583d1a9e99334bfae3f421faa6e10fc7a1f77d66d"
    sha256 cellar: :any_skip_relocation, sonoma:        "36abdc7b8fa2680125e50aca96752f0125cf03cd59f2bc1ce8e9985e078385a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90184c9df4f1c73801f54aa71ddac1609d8c20a1e956538d8979f6988d11096b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8003df5bb4ea7481a332e3c26469da0c1624d15bbcc8261675c56e90533a3c"
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