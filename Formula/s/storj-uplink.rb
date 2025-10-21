class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.140.3.tar.gz"
  sha256 "d4b1c5055719ca0326c11e1e1b456d50e4d82092c8346d194fb34c767d79c3ea"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77886ece963a571f4bd857769ad107c50fb52db8bf5d72162416f3974eaa631b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77886ece963a571f4bd857769ad107c50fb52db8bf5d72162416f3974eaa631b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77886ece963a571f4bd857769ad107c50fb52db8bf5d72162416f3974eaa631b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a8ec7f4117c1220f69077754a284b669d9127f099c15a4c381eac28d29b912c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247f471d50a3fee8def175cdb8ab95b949270cd2ddc227a928c5bc43d919e9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e179fe3e2770f916090c176f3f9d55854415294ced3d16beee44037b5b0d9d0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end