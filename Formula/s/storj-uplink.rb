class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.157.4.tar.gz"
  sha256 "0eabb7a61fd3774bd3dd54278adc1aea95693766014266bba718d8868c8be8e6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dd8f10f4aeae3d0effdc031a542e7807d6fef22712137bb5f2559a2285c770d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd8f10f4aeae3d0effdc031a542e7807d6fef22712137bb5f2559a2285c770d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dd8f10f4aeae3d0effdc031a542e7807d6fef22712137bb5f2559a2285c770d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac89c17f5a1e654b46bd8e302a6cb6cc3f4892c60e07ac5f032a04f5c87008f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e570166446fe297361855dec94adf1865497d76baa2f43d1af086ab3b96f84e"
    sha256 cellar: :any,                 x86_64_linux:  "6c6bee87ee8d0c646a26af21a2e0a571453f32c658f5522bd620a7ba96c42967"
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