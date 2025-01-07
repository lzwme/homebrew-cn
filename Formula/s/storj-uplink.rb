class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.119.12.tar.gz"
  sha256 "a20b9ac2262735c1c631a35d19492aa80d70414ce9cb84b2fe25ce736f5624d6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b3a1a5b3a2b5a7088bf7611879c6f70662a7f1c8cc25fd7d30b2bd211e8ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b3a1a5b3a2b5a7088bf7611879c6f70662a7f1c8cc25fd7d30b2bd211e8ac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47b3a1a5b3a2b5a7088bf7611879c6f70662a7f1c8cc25fd7d30b2bd211e8ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "df2bda9f7bdc5dbf857734d2ae6553cc5b09fc0ecbc45d05780cea3eb5b73359"
    sha256 cellar: :any_skip_relocation, ventura:       "df2bda9f7bdc5dbf857734d2ae6553cc5b09fc0ecbc45d05780cea3eb5b73359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a94f590c6631550258588f1f11db4a7db62780c868c408ef1181f270939dcea"
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