class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.114.2.tar.gz"
  sha256 "b2e57566eba5c039ae7cdfe32b92d42a15fb4b93e027dc6b8eaa6ef3067efa41"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2438966ea03bff266b303d552b457908ed33949679713de0823876e79956d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2438966ea03bff266b303d552b457908ed33949679713de0823876e79956d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2438966ea03bff266b303d552b457908ed33949679713de0823876e79956d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "e237baa34aab730a47445d989139bc297e9b60a21c36fc6e1ba8ae4970a37d87"
    sha256 cellar: :any_skip_relocation, ventura:       "e237baa34aab730a47445d989139bc297e9b60a21c36fc6e1ba8ae4970a37d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ad4ace16a41fb5cc35d02456d0e3585cff43e4868c944bd8cb9538dff811ff"
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