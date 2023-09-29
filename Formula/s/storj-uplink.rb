class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.88.3.tar.gz"
  sha256 "20d98f7b072e3e6f4bcef9a1156aaff27ef6972153f87576a918c394567d1524"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b0f031af39d21e4410ca446b14b8f8d2f45f1672da966045e3e974beafa715b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1d1c848de7fa5debfd6c00b42a06e6947dacb3048cd4306a572390fd5255358"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8800d89f7b658b10c60e34ddc15a5803f4135332c0faf1bcc08af1be1f597131"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfb9b5a0ad32b160c4a05c7a1e935e36a3e8b902da81213ee45fa425802e444e"
    sha256 cellar: :any_skip_relocation, ventura:        "442a9f0429b29a95606bfbf42ddcdb9029a1eb1d19f84d4269de8ea5108f8a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "9508d397e002d802852868e790a5c008972ada41b9238e98130c043885f1c9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "074172639bc795d552c8fbe2b413aa588d452597be8f0bb2fcd9f5fa61c1ffbf"
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