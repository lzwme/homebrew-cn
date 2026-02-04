class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.146.8.tar.gz"
  sha256 "a4c103d73961d2b0418104555cc78749d5e3b19b96158141c5a92fde8f5db09a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b3a90160935babe92a31fc411a82b523b77b242281863135991914b459c69c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3a90160935babe92a31fc411a82b523b77b242281863135991914b459c69c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b3a90160935babe92a31fc411a82b523b77b242281863135991914b459c69c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97dea23eb890c1c9cb897042444a589103ee9eff38b1cfcc5b7df360548a492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d552915018280d8cbf48dd55f14dc1efdfb2752c6c238c2554b865c75a07b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8265dd661c6e65f2f9a6357b444521deeaef6bea8d31db2abba6ef72dc9790d7"
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