class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.157.5.tar.gz"
  sha256 "09edb5e7e91fc50234538e80f04a9bbd718620c34c8f20c4f7127f1a844a35aa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cefdaec7e8c6fb4ce7903bde195cdfdc9ccb505606daa5d692efb2de89895522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cefdaec7e8c6fb4ce7903bde195cdfdc9ccb505606daa5d692efb2de89895522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cefdaec7e8c6fb4ce7903bde195cdfdc9ccb505606daa5d692efb2de89895522"
    sha256 cellar: :any_skip_relocation, sonoma:        "56dc85fb10811d043d77b668cd604bbd272c4a0baa2a5dbd89b13c5e0c95faeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7acf7d6e7e42e12705ffdc760eca59a427873c99105a6b0ce8f2b120897f5e4"
    sha256 cellar: :any,                 x86_64_linux:  "7a2bc1a742274d84377e7e6e859761dcd9e4672db655a4e7c45cef3233592287"
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