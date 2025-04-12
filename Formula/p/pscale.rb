class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.238.0.tar.gz"
  sha256 "bcb184db3f5ab28f42c9d4219d8a1a12fe0e358b215e8b3baa64d77df172d4ba"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d6828869b3fe0b18a8fdc0878db8e289d18b2492693a515294f5d97851fc12a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b95b61a6620d280dac07e8c7675f6994252c695a80b06ab7d2ec42037e0b15f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56f668cc19109232fbcfb97dd4c12fee5422b5fd6222f90845997c92492dab2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b36390cec0e1ecca1569d9b089fc190ecc6eb254a6590b2ed51fbf9700d4909"
    sha256 cellar: :any_skip_relocation, ventura:       "d0e70a51ff95cd6986a3f05ef9f4989fabaa9ca5e69f748b52e8926dd6b1b798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855507ab4f77e71d907f2c9d6e5009abad7f5584bdbcfa6cb26d567f681f360c"
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