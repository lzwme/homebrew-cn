class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.109.2.tar.gz"
  sha256 "d91a5cd0c253942c8da55a23dfbfa723c2bd5de85b0003442119c8067dd82ddf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2999cc0a5f6e0b97a6e702060a62a812a0a7cced16b2bb8adc34904993b777a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee8eda1adbea2655b0bd82ac24373b7438152fd127404dd0d408972283514c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7460d2c9364c537eca038a67a1225125523acc875eb7872ed4dc9c55de3d9e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f094a00cb2bc09eb98963e631c2c74944926e0c5c4b41d18114341aa404f678b"
    sha256 cellar: :any_skip_relocation, ventura:        "6fc06b2d75c0a8df2f98b3e41ecd0fcf8eedfd69373179959068e6302b61efb7"
    sha256 cellar: :any_skip_relocation, monterey:       "54baa21e06c67a1b0286744ce3a8719ff86071ef9f3d4302aef82509fb504a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "909515bfb128c21be93a4e8e5aa33bd4e5af32b270ead10e6df4a2186799d00e"
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