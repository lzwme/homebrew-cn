class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.118.7.tar.gz"
  sha256 "a1550fe9634c8c1cd78b88486ae09e46fddfb653fac56b1a8d71fdca4af097d1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50244ae6d776708b4f7092aa9837d1956791c6504f808d38cfe4d26daa176ef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50244ae6d776708b4f7092aa9837d1956791c6504f808d38cfe4d26daa176ef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50244ae6d776708b4f7092aa9837d1956791c6504f808d38cfe4d26daa176ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e91f2c05f5372b6e61218c5549def1d88f6b7335dad79b015d93038040e4ebc3"
    sha256 cellar: :any_skip_relocation, ventura:       "e91f2c05f5372b6e61218c5549def1d88f6b7335dad79b015d93038040e4ebc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd7bf8ed2b0c539c73822b776468ca4f1af0d43fe8fc7c74a20861838135fc7"
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