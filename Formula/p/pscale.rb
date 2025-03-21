class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.231.0.tar.gz"
  sha256 "89d2998f5197f3a56663fea704ee0cfd5cdb6a59220ef139b6ef32914b5efebd"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "684f53865d9d9d2260134a1b82bfdd2fb6a5811ef8376a461e0c60cb642748d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95158cdf38243d5546533ed794158d9c7a9d794f7a2c065060821045cf1f19ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1d3237a386a93ceff66f788e001d0db735babbff47b378a3d279593bffb1e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9daf0d60685a9464c541040f4090c408fdcc780b613f82e7852f4e549dab7ac"
    sha256 cellar: :any_skip_relocation, ventura:       "eeddd5f8c47daa4555bac6a4c1da7354285a73bdfd6a262957e8423393e7fcbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4134f466d9a903c44dfd1af1589207c984fa305f6d0bd8623877d466a72d61f7"
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