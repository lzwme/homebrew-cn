class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.228.0.tar.gz"
  sha256 "bd3df7f6f6922055dd23ee3aee6d71c30408fd5820a3f76155f2c1dc61cceb00"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58d69fd45752e3b8af398c8c3fe122bc84bc76e8d52f7ff4987bb82bc87dc8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4120ed6a67d42b9215e4095ced129c80957c8ed1c7261a23b17bb19f6ae9e78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "529e4219b7467fa305bb8ffb8a99f42104d1f5ecc009f77c5d4f61a02792ac44"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f9ed66c382c55aa1c8cf833569e52b40b6be05b5cc53ed048eeb7e3d224132a"
    sha256 cellar: :any_skip_relocation, ventura:       "3658206ef5c4d26276123b3a195fdba4c35b994164de432f165bdec1b36294a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8a0cb84d0a6bb677171e6ecb16265a86d89b660c57d43b6a8a959e80de8aa3"
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