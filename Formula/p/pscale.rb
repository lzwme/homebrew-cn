class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.245.0.tar.gz"
  sha256 "143f8f75bd398f848a646485ec646bfb2aad635f4626c28fa3f80e622cbd0a0c"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f041a0600f505aa4284aeb808fc53d7a0e18c1c5faa98c1e2cea3644b1c07c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b98bd8274c4c6789570d821b1758042d09d6e4059d25fca4dcc5da1f1b5ce81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ed445a1a1966ed2b4da582d461a7c46bf3e8d3257588235acb08d8025168063"
    sha256 cellar: :any_skip_relocation, sonoma:        "740b28940316f410fb804c53e32516f6ccd0b78a436a1f6cdf5560b62c40991a"
    sha256 cellar: :any_skip_relocation, ventura:       "0ec2ffff6198e83fa5334a5532f1ba48ed5ae3dd86c114560308a6f012b8e18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b8c0b874cc52ef9d5bc92b9bfa88aea054da2166b12084ff00abcff152fa09"
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