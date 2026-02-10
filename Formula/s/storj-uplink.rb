class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.146.9.tar.gz"
  sha256 "0d7a90caa78243b548598510fc2a7e37f55416d31868ed17ecaa60861936e20b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0532f869b299632ccb9c7737b6bccb949647fd42a15d8cd69fd78d673939d91a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0532f869b299632ccb9c7737b6bccb949647fd42a15d8cd69fd78d673939d91a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0532f869b299632ccb9c7737b6bccb949647fd42a15d8cd69fd78d673939d91a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4eae9769e6063581d2c92a7578b5c87096c5821e5b3d44add2651eaf60fea01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4434f523486b384f9b77e5796351a0f2ce10cb5b4edd2d3048a9fa2174fbc155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9232461978d7d3c0fd1b09801eacdfdab33d5faa3fc43c7c4d085235e054ba"
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