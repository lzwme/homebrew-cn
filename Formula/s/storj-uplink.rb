class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.164.1.tar.gz"
  sha256 "0bc1203476965b8aa8500e1faa474759480d6cd24a4b3fdbdd7aa6b377c05d0a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "750f5791c59b5bdcb925396f8b89857b7edd5ad2e974bcf9ec2cc065beba62d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "750f5791c59b5bdcb925396f8b89857b7edd5ad2e974bcf9ec2cc065beba62d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "750f5791c59b5bdcb925396f8b89857b7edd5ad2e974bcf9ec2cc065beba62d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "778d0f5e76120c1fa506a6ed063813ae7c052db18d990658c26dc4ea66f63164"
    sha256 cellar: :any,                 x86_64_linux:      "a13cc5c871eabdcf4975767c06905c0e68f4f18e03ca2f2e88df75bff40eedca"
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