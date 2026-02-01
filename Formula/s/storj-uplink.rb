class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.146.7.tar.gz"
  sha256 "3807868ab4dbe83469f18000b5313f8cda592fbe452f1ffd9da0d8ea3fea83d3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ee94264ab44481d07fe83f3624c0f30fb86898add6c1700e8cab0d818e0c53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ee94264ab44481d07fe83f3624c0f30fb86898add6c1700e8cab0d818e0c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ee94264ab44481d07fe83f3624c0f30fb86898add6c1700e8cab0d818e0c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db555982f025868b1983f57f595da0a9c14b76a057c9a1f3f9b9a077f4cec37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b2feb75e85585158eed566ee73fdee98794a54edf60556f93918384854aa05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d1711201f1f3906d28e31959e729d9c07e12d6a580f95751844234b30227e1"
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