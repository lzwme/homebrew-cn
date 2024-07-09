class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.108.1.tar.gz"
  sha256 "f9b4b3095007b53ba0a8ba50de91f0d017b89153cdeefef6f8e6aff0d11cc27b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7aa21907776f2468d78d70579f002d89cdf43c347f2ae5d8588d79571cb0ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6895c14233f45802e94bbc7a85e2b1d3d709b68b8c93fdc2c7a07f78d6aa9f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfaff3e670bcad5bc8bc738086a63552bc66423fba19c4b2fc0aab160d989a4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cba445cee2c83ddcfbd8987e8d0793e72fcc7cc3bec6160b0cdc08d42c9996e3"
    sha256 cellar: :any_skip_relocation, ventura:        "9857d6e48abe0954c005771a43ede2d1ad686fc9acffa6216d9a7c9e6b630de3"
    sha256 cellar: :any_skip_relocation, monterey:       "1633e568a089ff2006169d7f537dfbb7f46edd3c76d171450e606e5132aadba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af4fc6b1fbbdd1a7a83abda3ea10fe44ecb65aa1c43190867daab35ad3c7798"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end