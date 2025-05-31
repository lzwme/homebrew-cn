class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.130.1.tar.gz"
  sha256 "24452dc5b6b5087937ebe6bc705eed65064b9e523028e4b3a6372efada10971f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7ecfe864dd845ede8061e9bbf4edfa91adae955495b777a787ec16a0256fad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7ecfe864dd845ede8061e9bbf4edfa91adae955495b777a787ec16a0256fad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da7ecfe864dd845ede8061e9bbf4edfa91adae955495b777a787ec16a0256fad"
    sha256 cellar: :any_skip_relocation, sonoma:        "1de556484d2465a55b810d379169158c900e05f9182098c037726d6c4f1aa17d"
    sha256 cellar: :any_skip_relocation, ventura:       "1de556484d2465a55b810d379169158c900e05f9182098c037726d6c4f1aa17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cbc8882c92745518ed052a0c358355657cfd430d6348afae860a0006f95eedd"
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