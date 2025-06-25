class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.246.0.tar.gz"
  sha256 "114da654288e3ca15ed2c1aed176ffd838e281b5f4ad99780a373768e21b3aae"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033c8104543d1a1329889f2863f43a309e3ef6b577ab2db7f511c3607758e246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08086c239f86794d1132576522e834f71740a508c29466067d3a9739d6fbb0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f51bee0aa3f421d7989ece9df408ef9e72161230ad5112fbe5eefcfbfa7295f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "031a7f05c81ac08406fb57a79176337a8d9dd1c0e37cb5e6991f6af5870787f5"
    sha256 cellar: :any_skip_relocation, ventura:       "18d63feff0818bf9fdc02cb4c151680e09f45d4d935f615fb349d036e1b5afdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e9d4bbd85c4eac1f579b04bb71e38c457cc377981777a45169aa11e55991ed"
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