class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.244.0.tar.gz"
  sha256 "a0d4a7f3ace0ed2c28e115db034777ca9a0528d8d3cd636088d50d95edca1806"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbf4436a1b6999559ff69e27ca841d1847a9a786a90f52b0cc25ec42c0c5461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4978531395868335dd4ae8bf010a5870a8159afb62b3951179ea0e9b77e6720"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e21ecfb3b8eca8dbb28f200859b7f6f9417acc8dd23e29cbf3d76f7b12324f17"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf9cb1aade59f0742f41057ec8784e7892a7d59522ad5ba19fe13f6eea46ac4"
    sha256 cellar: :any_skip_relocation, ventura:       "9af0268a37e36891a0db92d3320ca85def5310f7211a8e9f8bcbb8a2aef2591a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d7ad1338e5474829c94b07d40036da9e8814c45666788e741053eaf5ee6cf1"
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