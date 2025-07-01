class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.131.7.tar.gz"
  sha256 "5d7a94e1231d8c1c87e90c0a78660e6814be17d6c11ce1c88e6e3b347085e31d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15691846957fe24394489dfc33e074a85caf564e75bfcce4dee3d0f9815afd47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15691846957fe24394489dfc33e074a85caf564e75bfcce4dee3d0f9815afd47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15691846957fe24394489dfc33e074a85caf564e75bfcce4dee3d0f9815afd47"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8a222fcfec99df64d86a2d66f7b1af710d037d1e0ccebf4cf142332cd52778"
    sha256 cellar: :any_skip_relocation, ventura:       "fd8a222fcfec99df64d86a2d66f7b1af710d037d1e0ccebf4cf142332cd52778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32441b3825ba6508891de1ed188fcb91da55d1b0b2e017725feb2f60fea9d27"
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