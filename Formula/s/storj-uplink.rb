class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.110.2.tar.gz"
  sha256 "99a124aceb28e854523c57a6358a880b3065901f631b2007f03f1be7a69a81a1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40a35e055d6acb7a9e9c47f87a8abfb017f23ea48f7303c570df36ea72ba319e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6fb7224cd5970cf37f3ce481ade045d8a5b68a3fd15ed747427dce2f28162aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd5c8ff0fe4c9bee04018b45196992ab692b9824f0fb726b2f04bc690a1417c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3443f4120ab68a53a03a71a1ac715a1aab1f15094d4cfadb3d2dd57b46d8b9bb"
    sha256 cellar: :any_skip_relocation, ventura:        "3c451e704674dc66a4e74518ed2938d536242858b53a64dd8cafd12d30f83504"
    sha256 cellar: :any_skip_relocation, monterey:       "b550dc3d1c2868975b44143d32cec340c2b273455f1cb86d2a7d37bd36bb1522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "930e3d9ee9001b619db5a489d1ee036429cdf94da6cf4cf2cafa12af3c25b52b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end