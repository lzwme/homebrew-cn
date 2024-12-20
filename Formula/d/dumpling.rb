class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https:github.compingcaptidb"
  url "https:github.compingcaptidbarchiverefstagsv8.5.0.tar.gz"
  sha256 "4c4c66fe60db521d5891368b484df45c319754d0964de185153555332bdf5a65"
  license "Apache-2.0"
  head "https:github.compingcaptidb.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57da8243b5e43d013a5c0f204cdc6eb7c5f5ab07a4b026478e8492ccc19ffe4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38e5ef82a063319c4d2a82bb6b28fe1c8ba97f1e74d8dff7840dcc3e1d6fa99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5505ad6a949e0e6bed519d6bea0b08fb382620cc3ec401b04c4baf274042bb26"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2cad6eb6fec0aa52de63460ae0d9082e958debb4b8c9e539235f50af8b0372c"
    sha256 cellar: :any_skip_relocation, ventura:       "f9a2be83c105e171dc7bbda74568e9840ed8fdc51e357d70b628cd167c698b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95babbd3485bab3659fe674afae6829e7397e90fc10cdbf1c8d98a32e480c0b"
  end

  depends_on "go" => :build

  def install
    project = "github.compingcaptidbdumpling"
    ldflags = %W[
      -s -w
      -X #{project}cli.ReleaseVersion=#{version}
      -X #{project}cli.BuildTimestamp=#{time.iso8601}
      -X #{project}cli.GitHash=brew
      -X #{project}cli.GitBranch=#{version}
      -X #{project}cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), ".dumplingcmddumpling"
  end

  test do
    output = shell_output("#{bin}dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}dumpling --version 2>&1")
  end
end