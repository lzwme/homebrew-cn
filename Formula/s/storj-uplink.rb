class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.136.1.tar.gz"
  sha256 "03f769b60254bb1026d0bd64a9492f16751b588d7c9c2fd1cc0c34d5f1d1a8e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029027d16fcd5303b7c9ca81cb4bbe5055ecfa85e1bbcc4e1296d350d28f99b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "029027d16fcd5303b7c9ca81cb4bbe5055ecfa85e1bbcc4e1296d350d28f99b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "029027d16fcd5303b7c9ca81cb4bbe5055ecfa85e1bbcc4e1296d350d28f99b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc23f392056444f44bb22c63a36b5275531963aee9bce84763314f171333261"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc23f392056444f44bb22c63a36b5275531963aee9bce84763314f171333261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb912e2f23ec6d40b3495b65fcaeeb27459128660917c1f58dbd11462f3d43f1"
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