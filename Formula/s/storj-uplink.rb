class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.158.2.tar.gz"
  sha256 "e3d14ffa83cfd313d98dd86057fbb6ae3cd47e87e33aa07b0371222638c1f8bc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dd734a25882bc161304f82a8b7c11b5b2caa7d6c93bb1624b04ba577894cbfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd734a25882bc161304f82a8b7c11b5b2caa7d6c93bb1624b04ba577894cbfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dd734a25882bc161304f82a8b7c11b5b2caa7d6c93bb1624b04ba577894cbfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "293f6bd0cc67a6de699748a2d439888e91a8ffe527a39a7259df02b176f6a6f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bc8f56b9c58373b26ce24fc83bc173d610aeec56b6adeb9a86722f1e9ccf682"
    sha256 cellar: :any,                 x86_64_linux:  "236abb3f10124aa77f116f94046ee1f5d18a6cf9a876e291167f7e2d60a14b33"
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