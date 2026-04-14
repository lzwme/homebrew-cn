class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.151.5.tar.gz"
  sha256 "95950ba746171d0c3580a60fe15c9c87d968127c3c37ea9018de7d8785150693"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8cd0f526aca4d7dd2f942772e1a5f0df8912c1dde516147c4c571eed7c5bdf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8cd0f526aca4d7dd2f942772e1a5f0df8912c1dde516147c4c571eed7c5bdf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8cd0f526aca4d7dd2f942772e1a5f0df8912c1dde516147c4c571eed7c5bdf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b367d440d9fb73981d06dc3b2d1407953e2419b4af507a0ca3cb388e36cb571b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8531e27c29bcb8aeb0ce6909a01643d9785a03fdc2851e793f74f9c69de1e69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90e9d55d84fb90feb681847a61e2cb46fc34cd90d68eca55df377f2851bef0d"
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