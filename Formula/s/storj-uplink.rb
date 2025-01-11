class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.119.16.tar.gz"
  sha256 "bba9b444d15a6013ccdf4a8945e6384c97719aaf1c8770fe1ab2d3b8b34a56ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3801550aeae88476304696b31d02852eaad6cc5fbc9dae5105c651b07c4b22d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3801550aeae88476304696b31d02852eaad6cc5fbc9dae5105c651b07c4b22d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3801550aeae88476304696b31d02852eaad6cc5fbc9dae5105c651b07c4b22d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c10eb14921cc546d7e002a77d1b750bbdfabc02438737ddb526061a609ebfd4"
    sha256 cellar: :any_skip_relocation, ventura:       "1c10eb14921cc546d7e002a77d1b750bbdfabc02438737ddb526061a609ebfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d3b784bb5f6236ba1a7056471faa5df27e244bb9bf698b6e57139c11857add"
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