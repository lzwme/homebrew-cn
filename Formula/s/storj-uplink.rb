class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.119.2.tar.gz"
  sha256 "550d4e1dd460d0e1830ad08a743de3da669b648f891d4edab241b997e2c0a4ef"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c1223f54c629eba579a02c26a660b792ca2836be5b7f65960f685ca252dd026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c1223f54c629eba579a02c26a660b792ca2836be5b7f65960f685ca252dd026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c1223f54c629eba579a02c26a660b792ca2836be5b7f65960f685ca252dd026"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1e98518150030ec7d16b0c828bd746eed34e5a0aac58a8caa0d6022bdbe886"
    sha256 cellar: :any_skip_relocation, ventura:       "2b1e98518150030ec7d16b0c828bd746eed34e5a0aac58a8caa0d6022bdbe886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116c48edd622b327d108af08abd8f10b386ae1ad54d959d4dc0934e2fbd32981"
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