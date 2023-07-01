class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghproxy.com/https://github.com/pingcap/tidb/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "857483386da87a9a92e17a70249f91d08367f7d2bae6c973d7727d8ce7b4a082"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad2f2ed3ce5abdb69485bdcbeaaa1d02ac879faf478b6f9f3a9d67db2eeae49a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a64176500411ab0435c0ade28b15ad768f5db4c40d687dcd8b982fad7f64f2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f801dac0ee1a620eca1d18652d72a77491be1045367cc37482f14ab872b1ada"
    sha256 cellar: :any_skip_relocation, ventura:        "e8f3f78e66ebec5379675b715444812698e905e44fd9612acf7efff5fd118aba"
    sha256 cellar: :any_skip_relocation, monterey:       "c410e9ebb31d966f44ab514265c356c1f30663452e0eefb0ab94f3c064832c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "82ce59680b9c02ab254e9be5671f2a237329bbd58caa2696d297ec346286fe2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e76e21443a8c155c1d160bb2f6b92586b7fb9fd0965b66e8678ae5e703e32fd5"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=brew
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end