class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.124.4.tar.gz"
  sha256 "f6c285c27ae4f803703133b6da502489233a724fe51a20caf98e58fb81982001"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a610cf60104e85a2004fdcd598364a49e418e183b5dac1e01876a6a8b7e53a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a610cf60104e85a2004fdcd598364a49e418e183b5dac1e01876a6a8b7e53a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a610cf60104e85a2004fdcd598364a49e418e183b5dac1e01876a6a8b7e53a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1789109361c0d2d23e67b6123d39a67e5d544adee433c8cbb59e7af14ee417"
    sha256 cellar: :any_skip_relocation, ventura:       "de1789109361c0d2d23e67b6123d39a67e5d544adee433c8cbb59e7af14ee417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1df4ef62c9de4e8a0f20447fb97ca5f0b63d301495734bce9402dcd142e9d8c"
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