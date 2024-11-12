class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.117.3.tar.gz"
  sha256 "7b6f5ba029d44ee5c59b2a19c294f07fa108ad963707d48218ef7be2cba58f83"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c338974c284b3f87bb34a4274c197e17417a4b27f17ef761c1e73d742afa547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c338974c284b3f87bb34a4274c197e17417a4b27f17ef761c1e73d742afa547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c338974c284b3f87bb34a4274c197e17417a4b27f17ef761c1e73d742afa547"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc2794226eb3387a0edfa9198419f461765d03b32c282381721d6e7a629ff32"
    sha256 cellar: :any_skip_relocation, ventura:       "7fc2794226eb3387a0edfa9198419f461765d03b32c282381721d6e7a629ff32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44240aad5e2008825538555bb6f2a83655a3576eb9230794db0712f52c1e7906"
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