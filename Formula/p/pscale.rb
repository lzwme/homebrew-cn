class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.255.0.tar.gz"
  sha256 "beb676eaa9e3d3be09bfbe22d4f35edc661f43b7cd71f3b0635f22b192d82d05"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40466bf975630c109ed496585d58527a6d8657d4fd422df3d7cbef0e26051e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c7131c32c4b934fcb627cf10b5502cdf20c9eec9231c9748fb7394c16f4699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b46a209c1c9147d8df8c0550d68abc574919cc04b7539f340c879726e901928"
    sha256 cellar: :any_skip_relocation, sonoma:        "594d6d093d366d79bfb32390381747be87c06ce00038c1a3299a017135605760"
    sha256 cellar: :any_skip_relocation, ventura:       "2e212d9d31211eebda2ae37720601bf3d84ac801c88b882ae7b796f2b424ca17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1406e7516c28c5e6103ffa2132c7a3e359bc90c43edd4ff9392e4310839f7a91"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end