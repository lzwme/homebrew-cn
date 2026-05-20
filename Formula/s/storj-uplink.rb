class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.154.4.tar.gz"
  sha256 "75b5b35e79ccdba6b172ce511ef7952e5683f320277e50050ee901c9627f8cee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b688efb495bb180c9d84b53c26005b805c4f821983490f3ece298c4bd38e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b688efb495bb180c9d84b53c26005b805c4f821983490f3ece298c4bd38e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b688efb495bb180c9d84b53c26005b805c4f821983490f3ece298c4bd38e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b444e0d4c3c8ee4763c3aca1985fa63ab34a7cfa5e9444ab1ac707d508037d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a13ff57056d7193cd1564681e8379571cd25753481a5d51c7d5fd24ba6079b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d44d6c127ad20949453a8b4c277c30a07dd9885841be22d062002a839a2a6b0"
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