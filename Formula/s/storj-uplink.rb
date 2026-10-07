class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.164.2.tar.gz"
  sha256 "b54a10cd5a5aec4001a390be5cb4b00d98a43ee89b8ec528381274bcaa1066b7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be9af81a0c49399acf3edfa50d5af8296efc4b29498aa6fa32c02e55a567afb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be9af81a0c49399acf3edfa50d5af8296efc4b29498aa6fa32c02e55a567afb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be9af81a0c49399acf3edfa50d5af8296efc4b29498aa6fa32c02e55a567afb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "529cbec58c45d89f16787bb81a2426a844a654359737acb3c8d5dd5b8696710c"
    sha256 cellar: :any,                 x86_64_linux:      "b160a02cb9d43b926fe5e5cb31adf4b268bd8d03eec4bf73cfe405558dca0520"
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