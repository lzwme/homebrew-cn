class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.143.3.tar.gz"
  sha256 "7d03d62d81fb3abcdc0ad5b0ecfdbe166e43b35b1e762f08d8cef6f789b4c51c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a16520b9925159e8ace3973ac8a8c2b68ebabcb7b7cda4a309c31bd270eeb377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16520b9925159e8ace3973ac8a8c2b68ebabcb7b7cda4a309c31bd270eeb377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a16520b9925159e8ace3973ac8a8c2b68ebabcb7b7cda4a309c31bd270eeb377"
    sha256 cellar: :any_skip_relocation, sonoma:        "da47748cf27049f8d383015b2197b2fda76739d7e626f056e4f9f7340a511072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849c54d7b33f65e6b96547230482e2df62c5351349f4daf168663118b43f8569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b223ec437b59f83ba06bf1eb9d60f6079ab940caaca7f5bf81213328448158b6"
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