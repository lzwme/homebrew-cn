class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.236.0.tar.gz"
  sha256 "19192bda6eade17a2cd63267ce922511b8886397e06718bdfbc61db28ea1d1ac"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a2d2f71400c09cf49871fdb42925d80ff5d2b455ce21798ce62b45a01114120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110a228412d73711dbfcf36a1349b93c145f0df5e21400d2814257f4ab14d85e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e906ceba018f60b521c7638313fb4772c040d86f0a22e2a13410947918c118f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fd7bf3dd58fdc457604c28854c182fa3b3c866b251a6c5865164e8a83b54ded"
    sha256 cellar: :any_skip_relocation, ventura:       "2152c1cb1dfc77eb0cdeab44f4ae6b1387ce6462a25d2d3e10809f56103d4659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b139144c32870f9e126738ffbf6400937cf6f10611840c320f2df2926a81e89f"
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