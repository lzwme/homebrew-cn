class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.151.3.tar.gz"
  sha256 "84dcd159bae9c01d33be4780a316716278079147a7a508869b38116e12abf9b7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9972b8ff0f5f9086fc07e0d5ac9a94f5a8ce18098e2cd199fbbe7e3f38f1c1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9972b8ff0f5f9086fc07e0d5ac9a94f5a8ce18098e2cd199fbbe7e3f38f1c1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9972b8ff0f5f9086fc07e0d5ac9a94f5a8ce18098e2cd199fbbe7e3f38f1c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0bf3bbee2f66f72fc32855833d73b1d558effc1025fe3968b29c2d7aa5b24cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6552757954338d8e15d0fa667da66832ff5bc1f97d64e6630a095d885753a6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c8c7e5e46d662a5fa65e7c5296df8732b13df14817e2d5004443d946aba8fe"
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