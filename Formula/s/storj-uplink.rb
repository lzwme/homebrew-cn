class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.129.2.tar.gz"
  sha256 "6c191aa90064a255ac6bde13ca425af75efd72ffc2c3e0f72b6bbd92190016bb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c67fd40e93e423c6e50cf9b00f472583a6a720c659fc271ab621a1d98a0f0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c67fd40e93e423c6e50cf9b00f472583a6a720c659fc271ab621a1d98a0f0d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c67fd40e93e423c6e50cf9b00f472583a6a720c659fc271ab621a1d98a0f0d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab5c88605b1901b006c78667199b00597934f8d21b541d82164319cfa48553d"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab5c88605b1901b006c78667199b00597934f8d21b541d82164319cfa48553d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "883335c36429206ea8ac97e4f5be966b38d453064df101cb26eb3e170dc888cd"
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