class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.165.1.tar.gz"
  sha256 "1e14c445446450e1fb5a41e98bd456b62b39a4f553db326e33725e3db509435a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a704a352853e297ddcb11a4eeb0ec3f4cfda6a14ec68aad8d438da3b7c3ac69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a704a352853e297ddcb11a4eeb0ec3f4cfda6a14ec68aad8d438da3b7c3ac69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a704a352853e297ddcb11a4eeb0ec3f4cfda6a14ec68aad8d438da3b7c3ac69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc1fb2c37af5b5809141b0e1e983ee9121096ba8285ef79d287cab56e4340018"
    sha256 cellar: :any,                 x86_64_linux:      "ab5c4b208ac5e18530b81edc460940ed1ed2f5f13e06815f80f43fbb19963f09"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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