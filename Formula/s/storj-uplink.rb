class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.119.15.tar.gz"
  sha256 "8ea114452a0cc8400a819726c3689b663ed493e1e06cb163e159a437f60842af"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8816bc02912f00987b5058285074277b6b56ae588fafe1c6d961bc50546d60fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8816bc02912f00987b5058285074277b6b56ae588fafe1c6d961bc50546d60fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8816bc02912f00987b5058285074277b6b56ae588fafe1c6d961bc50546d60fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "90e7ffa3b2a4d3dc15adb1f5fc8e511157f82ed80240b665e1060a91847565c6"
    sha256 cellar: :any_skip_relocation, ventura:       "90e7ffa3b2a4d3dc15adb1f5fc8e511157f82ed80240b665e1060a91847565c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4923f7c1c6a7554d5aa5fdc00d42f62dd2f528a869b8e0490a5a0f87d7b4550"
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