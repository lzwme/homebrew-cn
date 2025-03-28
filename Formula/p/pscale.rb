class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.234.0.tar.gz"
  sha256 "a2d5fc6a53e0bf13e08df4bc4530fa91e029f7c30a0fb52ca5f271469cc55a03"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673cd4eb9403ae82a1713180a3bee14b3a5808fe1c1961048a7e425a8331ad18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dad9fcefc7c1f994b7c619544796a80e9c8ed1cfc2016ac0f5f30fb76bddfa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa4e3c471e5fe3fdcf3c0f4a221c74c208ef4afe559ac7461d46815be09e2368"
    sha256 cellar: :any_skip_relocation, sonoma:        "a411c301de407c74d29da1ad12f6a4a1521073b46685b0936d19251deae6470c"
    sha256 cellar: :any_skip_relocation, ventura:       "9d9847bf0e7a8680baab910e74b3bad3d380b568175e36b6d574005ac29a94e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f617bce14e79eb552d97c784c2ae8a5de02170250dd93afcccd47658e383e8c4"
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