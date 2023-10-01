class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.89.2.tar.gz"
  sha256 "fe99d38c4448e74adddb28feffcbcfb77116bacef40f748df29f403e073006ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c249d724d51d2e9c5f7d41474dcf99d1a9858a80621ca9d8919a736f06daafc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274c409eb08e8dc0d1cb03c5a814f962a6b479c0c471bf999b382e2bfb4bcaef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f033671c92ae6406277ecaba6efe1a1d61784964be010d4c0b530085c3cc8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7f20243930522db62304b7427497b04bf30e3bec2e5873c02fba6dd03cac81"
    sha256 cellar: :any_skip_relocation, ventura:        "2185d4dcf55262655bd4df5acf416c16d153b053b992bddcac3a7f458ef51adb"
    sha256 cellar: :any_skip_relocation, monterey:       "fdda8e3a64fa45660043650a44dff61d6afcb8c52e1cc2d81afd70fc4be8522f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78562dd9824a72a4472b32a855bb552154a80035ad189001b253c35ce488531f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end