class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.122.1.tar.gz"
  sha256 "fc5a5f9f078f4ff619d06ed0cad8c6b8b84086297c265b354467929be3f06b97"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy ifwhen
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bd16df23becc288e386c16e2da22fe13862c0aded449733c3a764e661517cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd16df23becc288e386c16e2da22fe13862c0aded449733c3a764e661517cce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bd16df23becc288e386c16e2da22fe13862c0aded449733c3a764e661517cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c4f36c4fc8c7d901962c5753a87987eb1b926c4b6930c14a52ab247139461b"
    sha256 cellar: :any_skip_relocation, ventura:       "e5c4f36c4fc8c7d901962c5753a87987eb1b926c4b6930c14a52ab247139461b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e0d34561bc9c8542a84d72207f726465d9682c16c82988b1331a487101df00"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end