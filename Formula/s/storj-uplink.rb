class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.152.7.tar.gz"
  sha256 "5c7f13e1ed22cd7ad2aba58bfb2e4680d7dfcc39a8ba6674812ead0c94b51c92"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96dd3b3fe5413a701e6e7f642e09a748273a95cb44cd28eb34e230db07efc408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96dd3b3fe5413a701e6e7f642e09a748273a95cb44cd28eb34e230db07efc408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96dd3b3fe5413a701e6e7f642e09a748273a95cb44cd28eb34e230db07efc408"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c98a08dba7bb43938326dfa1f98db325c3678cf4fee2337b624cbaddfda82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d2fa655d750a5b746e2832575d28a6797028ad6783baee62182246b3d316473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37c58c9d55532c9284ea344b1fa7770780cffb7c8b6c04c5386bd206e11e7f4"
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