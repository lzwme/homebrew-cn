class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.141.2.tar.gz"
  sha256 "7a939f34485cbeb04fdfbeb84e68e005637a88f08b0f3c75c5b69a36c144b5c0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3624adbd0963382eb09c6b5cb8fa1215b547dba56b9824840f65ffa995742bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3624adbd0963382eb09c6b5cb8fa1215b547dba56b9824840f65ffa995742bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3624adbd0963382eb09c6b5cb8fa1215b547dba56b9824840f65ffa995742bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8efb0aebe88ad10602d8df3ea90d751016311ea5f0c9e1a8d577bb0e81f23e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce0fc4f7d3f1b8115dea5253f244dfe54aa9a318022b8a8bcbc54b3ff1b13dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a1472737580d5e7c9570a0fa31fed52ff32168331d06b6f7ec5531c43c6336"
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