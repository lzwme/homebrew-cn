class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.2.tar.gz"
  sha256 "5360443b39dc1e6bf4776e383f7f7ce8bb61f7a80a28fd611ec5f8951958ff29"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f319fa2bf059776c2392fb04197d54bd51907d4450ec37b6601c3c256e0ae35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f319fa2bf059776c2392fb04197d54bd51907d4450ec37b6601c3c256e0ae35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f319fa2bf059776c2392fb04197d54bd51907d4450ec37b6601c3c256e0ae35"
    sha256 cellar: :any_skip_relocation, sonoma:        "72482fc1e71e5b88ecb99b781c68c4111d2b55f8716dd05f7868e700fbe8c147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1e4ecf72af66b8ab75050759c603b50295fd8776b257512fc4b2ba058b34d8"
    sha256 cellar: :any,                 x86_64_linux:  "a2f9c788757dd9bc46bd8930864c3e9483738f48f1d50fac6a9ee3bd1352c16d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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