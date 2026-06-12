class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.155.8.tar.gz"
  sha256 "25a9370ecbe650ba8ff3ca39b7353254e3e21c8588585ee6608d2864195b7506"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be325638a20de33641b518244292a300d1a4a2ddef7f3459b8e5317131cbed93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be325638a20de33641b518244292a300d1a4a2ddef7f3459b8e5317131cbed93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be325638a20de33641b518244292a300d1a4a2ddef7f3459b8e5317131cbed93"
    sha256 cellar: :any_skip_relocation, sonoma:        "ece43fcfbc9ad0bde83d414faf6afbde60c469abcbf2c4dfcf8bde44a38e61db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858f2ada833517068ce96079ba627de1fd2770a11477c9a9a4aa7e1386ebe491"
    sha256 cellar: :any,                 x86_64_linux:  "bba2d6b0c13b7c397f4336b95c285aa38316851f92b1a00bed498895ff26c736"
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