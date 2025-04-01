class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.125.3.tar.gz"
  sha256 "21c2de2114fc1db2fcb1e72fe2b472cb312af9ac81d8e06ec0c30d0fc78f0fe5"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy ifwhen
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "188460dfbb749a195c0a8ae9d7885ec28b9b63e6ad70b76fc7a114a7ef69d787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188460dfbb749a195c0a8ae9d7885ec28b9b63e6ad70b76fc7a114a7ef69d787"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "188460dfbb749a195c0a8ae9d7885ec28b9b63e6ad70b76fc7a114a7ef69d787"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b1ec9ac16e255a62c246da2b573187edfe9ee6c4a901d7011404f1231e99391"
    sha256 cellar: :any_skip_relocation, ventura:       "5b1ec9ac16e255a62c246da2b573187edfe9ee6c4a901d7011404f1231e99391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41fcd9959da885c81ba55d84b4117bf5408803c3117c66d7a7a03e8642ed1ceb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end