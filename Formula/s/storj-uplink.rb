class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.107.2.tar.gz"
  sha256 "bada95a2974e603d92927ab2e8484c91951f4e109a309c62c1c4f72c135ae0c9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b337394436c5f923fcbf582c1006d042c6c1d7a9d71eaafa7a358859a0a3b9a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629e1638b3781a3263070e7d1ef12f25033b2df26b2970f7176293f10540cbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0440075846353e4846f9b77911a55de2ee9d31b45562e0b23615696ec0d5b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ce7a306597a7154b8d0b404488d6fe759c133c41cef9976816be2d72e845b96"
    sha256 cellar: :any_skip_relocation, ventura:        "1553734ab78914c58bffe85f2913e688eb9c87f0368bd843bef013602f559d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "efe433babcdcdec3fd532f71d4a424c458f93e70fffed53788024e361219d2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df184c0f27c043e13113862b94fc4f8673614532cb7613689d2202b505646b10"
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