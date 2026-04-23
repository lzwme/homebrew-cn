class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.152.5.tar.gz"
  sha256 "ef55af1c8bbfe2b84e7e4e1f4b4ac2faff17ac29f1270ff9991acaaf85b13129"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3136f033fbb3214d293221a09c5360ce4a9a26af8bcb50b1a0e380b1fc73bf48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3136f033fbb3214d293221a09c5360ce4a9a26af8bcb50b1a0e380b1fc73bf48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3136f033fbb3214d293221a09c5360ce4a9a26af8bcb50b1a0e380b1fc73bf48"
    sha256 cellar: :any_skip_relocation, sonoma:        "149b1747c4915edc98f4a917f35e61652fdfb727e297222bddee98fc652d0845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d159758db632a4a1085c45b0b351214ace1ca82ef1eab51c718976b32dadc08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827541a405759134515d3d1a5d9d00d68ec0fca0705c925cab6e06afe0c7b1cb"
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