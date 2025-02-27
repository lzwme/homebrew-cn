class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.223.0.tar.gz"
  sha256 "f0c2d9949d677c8f7c96bf5cd86ecda8c7c8b99036ac795bb775096d0a37525c"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03dcdabbdbf85a7657c8e847d532234bc41315e5453f9545ecb31feacf9d7040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f352734655b85d21a532f9b0d9f215e1290f9430925fd11c0f88564dfc39510d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b52a9d68bc3f8e970ef854f0e58481e7a208e740b57f6a0ff7ca8810d6e91f9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "126fcf1f5cbb93cc4fa6d848da917101d59906f2c24af13b0beca701d0f51c1a"
    sha256 cellar: :any_skip_relocation, ventura:       "38f79e5a6a92646ee1f08e9c566a620b83348778581eb67c2474d5ba4062d329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9d5d94d0b28c7eb7f67803d1418ac4b5a311e522f771eac464f8595993760b"
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