class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.123.4.tar.gz"
  sha256 "992486a41750f5aeb2057118e4d399a15c822d2710165d0f1a0234291158ba1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67797e71a739bac2e3dbfa5b5f437fd1dddff553df8238b2955ade609a4835e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67797e71a739bac2e3dbfa5b5f437fd1dddff553df8238b2955ade609a4835e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67797e71a739bac2e3dbfa5b5f437fd1dddff553df8238b2955ade609a4835e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf01068269ed97d35df8b43d087997e2e58339b4d9086f9c23562ff9b1bd020"
    sha256 cellar: :any_skip_relocation, ventura:       "fcf01068269ed97d35df8b43d087997e2e58339b4d9086f9c23562ff9b1bd020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "193d444eb2aef288d195dbb5ffee2117ea0a2421dd1c0422c53931b1dd745ae8"
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