class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.163.6.tar.gz"
  sha256 "578757c0e7bb56f487089f3ea2706180560132cdbb0b2c92fb7918a89a43231c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ff99e85935e1ab049bc42020a4147349097894885d3bb320ba3b23ec18d8b22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ff99e85935e1ab049bc42020a4147349097894885d3bb320ba3b23ec18d8b22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ff99e85935e1ab049bc42020a4147349097894885d3bb320ba3b23ec18d8b22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4b00c644cee2c5197a8d552fbcd95e63d472d4035ee4cd1b2e7eb5de390237b"
    sha256 cellar: :any,                 x86_64_linux:      "fb92c2774096143e3ad3e1ead41e48e3cdadb4870959419b2184273e1e8af443"
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