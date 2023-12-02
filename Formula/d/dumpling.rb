class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghproxy.com/https://github.com/pingcap/tidb/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "d7514e5f8c787988540d0614aa75f573fe502c9a8381e2628dd6350b8db8e478"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "603d51eeae6d91ff21c7303927f5c45f59e97a6d2d1693bc1b74c753f1f3f165"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1987f76095c2d56d17987d98c929b49942bb56f4390ad8b637e44331265849e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78305859b784cf8ce1b5f86cc6b43c372ba19dc4a3c25183bbeb27976d316974"
    sha256 cellar: :any_skip_relocation, sonoma:         "844bd50b70bc079f4ad644a484ef63346a359260bcc841f907b5d275d84a34ac"
    sha256 cellar: :any_skip_relocation, ventura:        "3e937e53af62ac94f491998f98638d1740ee17adfdf7d19325c2c14e830959d4"
    sha256 cellar: :any_skip_relocation, monterey:       "d2d7f2232d82b2007a468f6f4e29d6f14ee2ba6fb60fa305200692bd3f195a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946ea2f6edc579fec6ed6511d50a1603d3eca3fced9d1d48da19309ad46cb356"
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