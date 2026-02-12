class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.147.4.tar.gz"
  sha256 "91540ba2dd146105611ae8c1c347b35a1d6655589ce46d7effbebec955b5fdc9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39009078871383da2b29d8bf476520f771ab3b7bb0622ca8a29f547a77ecc35c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39009078871383da2b29d8bf476520f771ab3b7bb0622ca8a29f547a77ecc35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39009078871383da2b29d8bf476520f771ab3b7bb0622ca8a29f547a77ecc35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a28e1ec6f7573660e94601ce8afe58b11ec4298d65ab4f3519308d90fc14888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ba9918e6b458bba98b5bc7ccdc0f16adbe4fcc1dde679952e8ba7fff232a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e9425e43e217d6ab70cc584923de9f1412184a0df6f39d3a388d5ee7670640"
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