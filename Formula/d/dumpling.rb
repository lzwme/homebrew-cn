class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.2.tar.gz"
  sha256 "b176a4328e77a965d370d6f9f34e8ebf2f7c11da54cb1fe0f47a3f32f5b27783"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d127a47686a7ef76fc82de96ded567ef08bc7b4651e080752260ae79e8c221bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240742f5cbdce35cc744bd63da668292d616a023b19d2165c3f5ec617b8447ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a8260efc84964d32f576d8b244ac3de83007d77373886e319a17cfc9fffa82"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f453daa40ff68ea4df66c8e73ff49c1a595a1d84cfafaaae2ed1414b61e302f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855441b1c24c7739fea4ef98764972e493d49cec54fe4f2326364d244d5c7cd3"
    sha256 cellar: :any,                 x86_64_linux:  "f55b4a1e7a20b55609f4a4eed43def59e3a407201dadc5734fa5d579ced0a704"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{tap.user}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end