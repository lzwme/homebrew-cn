class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.1.tar.gz"
  sha256 "84acf6eefbbfad1a537642f307d399590d7455321484acba0d0668a42bbe4923"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368f03803b70b15f4c6c2d98e82d6fc422307b24e76ed82dc9ef0fb68d1bac73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368f03803b70b15f4c6c2d98e82d6fc422307b24e76ed82dc9ef0fb68d1bac73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368f03803b70b15f4c6c2d98e82d6fc422307b24e76ed82dc9ef0fb68d1bac73"
    sha256 cellar: :any_skip_relocation, sonoma:        "befa67f454f0ad9fac09d959a84f025678dfb3fce013ef3566aac932695a88fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d97454debf2669da31f39dda44f839899bb5e92c3556d62115d3efdfd7fec7db"
    sha256 cellar: :any,                 x86_64_linux:  "58ebe1ed80d6f6bfc192d695c7907c41f05ece417ac090c9d459cca6a2423969"
  end

  depends_on "go" => :build

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