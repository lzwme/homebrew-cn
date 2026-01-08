class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.144.4.tar.gz"
  sha256 "bc1cad2ef193c3f4ba3db12242c809a6886d92ffd06dcc6890124733e2fda009"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4943d720b0c7a9f3c556af232a4371e4a36ab44f52754b06b82735a650a7ef7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4943d720b0c7a9f3c556af232a4371e4a36ab44f52754b06b82735a650a7ef7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4943d720b0c7a9f3c556af232a4371e4a36ab44f52754b06b82735a650a7ef7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d26f40c3bd0c39ad617341dca2eca86bae2a154afe4715dde357866da84eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48f9dafd1291b02561ccf7c8f22c5f0c5366e69b1c0f21d98d9eec22da8d3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a574fd3193751d97bfde3a4ae49e5f6e0914fe049efda8798624317f82ed67ae"
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