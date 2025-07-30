class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.134.2.tar.gz"
  sha256 "e23764f09549c38a47feed391160567bc814b8ae4b857ce84bdfda1177ce4879"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d86d40f085b605bb8d2f5d85ecb396d65ddbf05dfd6e9dcb02ab23d18e9ca24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d86d40f085b605bb8d2f5d85ecb396d65ddbf05dfd6e9dcb02ab23d18e9ca24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d86d40f085b605bb8d2f5d85ecb396d65ddbf05dfd6e9dcb02ab23d18e9ca24"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff1f05f87c508652099893865ecd810a5d468ef6ad170d0f783dbb7ea27cb519"
    sha256 cellar: :any_skip_relocation, ventura:       "ff1f05f87c508652099893865ecd810a5d468ef6ad170d0f783dbb7ea27cb519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae2148380a21071804e5e1915c3be363f547cada40f277cce49f165eacb4407"
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