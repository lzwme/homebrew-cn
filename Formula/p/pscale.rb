class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.226.0.tar.gz"
  sha256 "a2ffdb5eea5488fd45291119410d2c46cba31655c82dba68b3a3dffcea32e890"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e08547825ed32ec8f8e3db138d663b79b82f449a30ecb4c32dcfb18c5f16ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab9155f56e2ca13423239412bcd2410f131c8a6d8da6b4c41ece55faa2942e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ecd998ffa133efcd53ed3454595b097448f634497335fc724ea40009ae81fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcb049bd9181d817fe40584ba889a4687c08b44b2cb2114904e67571171d7c06"
    sha256 cellar: :any_skip_relocation, ventura:       "3de783743503b6ab61f24e65328eff29215703b36a9ff8371b9be34c2d6f8b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f88efa975f09b83007d86398dba7169426f5e790a5ae018cb50e7a09f149eb1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdpscale"

    generate_completions_from_executable(bin"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}pscale org list 2>&1", 2)
  end
end