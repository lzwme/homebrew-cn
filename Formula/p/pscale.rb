class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.222.0.tar.gz"
  sha256 "abb90f8f74c49321cea85d2a1ffa8fb348d67952f27dedd1e40b949af0fed272"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1d731cd12b284dfc8c53f35dcd50140dda34e6f8d1b1ca8aed9deaa33504e80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5ce693ba7b9b04489953d202df0b32f7869576db8dadd8d60818bcb406da84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d479098a29eab2fb8d696fcde4d9b79a1c396dadd58129fde4871fd81960035"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7082f98a0de14805c5d2e92daa2f68c69ce1ff37dfaefd0a255c19a3cee981b"
    sha256 cellar: :any_skip_relocation, ventura:       "56e7eb08a8f48524f1b927bd980082a68050b7e95e925c711bef1ae5fa951085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc560ca7f530286c13f4ac9911dc8841faa74a7e85727d6e1943622a84d8a05"
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