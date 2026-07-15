class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.160.2.tar.gz"
  sha256 "3d9a06237dc76ae8576bddd091c57bdef22b8daf35d2ab08bb96146ed1ebd8e1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c138e1776096831d78519d4a5930dcfdeb0b3875df641371589fa1363f1de059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c138e1776096831d78519d4a5930dcfdeb0b3875df641371589fa1363f1de059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c138e1776096831d78519d4a5930dcfdeb0b3875df641371589fa1363f1de059"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d15b74a9b55cc6e8f1c39029f71c5eb8a7084f20ee00f132eeebe60092ea909"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de48512dc4be778771de67f69ec715cb2eafebbdf6e60aa5ee294e21f056a80"
    sha256 cellar: :any,                 x86_64_linux:  "1e418b72212c3a27f0a001507c45945af6dcb6f731091c6aba6c7da55e80b0da"
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