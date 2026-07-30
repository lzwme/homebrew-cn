class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://ghfast.top/https://github.com/pingcap/tidb/archive/refs/tags/v26.3.9.tar.gz"
  sha256 "a2641d4157abdf1335acead791fb47cb47923ff0a425d4e2d14d14a1a4b39c20"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce6c0d9ed84047dc2a8ee4b873b54312f6c939dc3497183e9e4389015ee31eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d268be16f30db7f423018361d54e413490d0c1eec5d9c3a3c75951811e5c82af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e677a8d34d5415fb14ca3953874accc5cce64ee3a155d176eb9db51afb37acdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6b3c3b03119e683cb11328cb9e14d2cbd6d9de0e1826cce7c8734fc487f9b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea75a6488fe089259ff5e8e7471e610e7bbe4cdca7e6130cbdb67e9ce952cc00"
    sha256 cellar: :any,                 x86_64_linux:  "0199fdcfa7087f977cd431cf75afcbf19a6476de0d06a5dcbb7c543e1bb33fc1"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
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