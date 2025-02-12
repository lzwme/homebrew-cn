class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.122.2.tar.gz"
  sha256 "664fddaa1c3f442b763152af8d3cb0d535baaded8cf30ff8d0860b93ef4a0e60"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e6b1a2ba84ffefcad5f148a8ea0770bc11794fb7b42601fe55a9d4d7f6144d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6b1a2ba84ffefcad5f148a8ea0770bc11794fb7b42601fe55a9d4d7f6144d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e6b1a2ba84ffefcad5f148a8ea0770bc11794fb7b42601fe55a9d4d7f6144d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "da90c748018d696f2d78e60ee07920ac316cae962e137d565bbea373197d81d7"
    sha256 cellar: :any_skip_relocation, ventura:       "da90c748018d696f2d78e60ee07920ac316cae962e137d565bbea373197d81d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2027b6a7a091c94e1b437de5a901c57b840a2b03f2f86b78153240e8c67d72fe"
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