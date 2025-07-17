class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.133.5.tar.gz"
  sha256 "6cab49441cdc3cfeff51e6d7c71a13c49e4df1189aa9a219ef9381d1f965fb1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1babf6b96a8eefcbbc63c81e1ec51ae6ff912cc10ed7a7dfdc44341fee57a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1babf6b96a8eefcbbc63c81e1ec51ae6ff912cc10ed7a7dfdc44341fee57a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa1babf6b96a8eefcbbc63c81e1ec51ae6ff912cc10ed7a7dfdc44341fee57a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1878b4ef6cd00c3f71e07d0b10775175349c680a358c65be59968fa108b6bfc5"
    sha256 cellar: :any_skip_relocation, ventura:       "1878b4ef6cd00c3f71e07d0b10775175349c680a358c65be59968fa108b6bfc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574422e0d2886614e7ba1e4fa979d9dc8a7affc8b4343db3eb2901bb0e60542c"
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