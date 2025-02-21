class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.122.9.tar.gz"
  sha256 "f743f30e2565a8841de99abfef82ab5112252c49420a6d7e9eebdd0533bd4ad4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d8c496bcaf4e65889490e8e5ca7ed13766507989b2ba1fcc5136c766a2ecd36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8c496bcaf4e65889490e8e5ca7ed13766507989b2ba1fcc5136c766a2ecd36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8c496bcaf4e65889490e8e5ca7ed13766507989b2ba1fcc5136c766a2ecd36"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac822e71fb5933f0e5f7d6eebd0583d7a68c750e54994056cc3220c437b39d13"
    sha256 cellar: :any_skip_relocation, ventura:       "ac822e71fb5933f0e5f7d6eebd0583d7a68c750e54994056cc3220c437b39d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4618eef966477a0f27e408063b04e078815f2233b4313c19f6206005143a42"
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