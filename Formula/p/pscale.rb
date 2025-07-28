class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.249.0.tar.gz"
  sha256 "a49235631c6119effdb7b5bfc0dcec345b459372747a1e86555acfa619029d44"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bb3681f97fe4c0cedbc006af660520ae0d62ba0da56368ecf9870e271732188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9b67338598b6080e044e32bb8d9730e3f3d5e1005658bcd8e6d36bf595224c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4a2d4ffb0e335a96ed8d12bb88005598aedbc49f9d4f3b196d6c554356577c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb471cb2c415c489e8686501928fdccddbf2a2ec172ffd82ab8ee7be817c8c8"
    sha256 cellar: :any_skip_relocation, ventura:       "a86e49f33ea7d991fd11a98a2b836905bc1327d6e136bd3da3e7e7b3280416e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87fcb8b86193fdb5b467bac4da42c24558ec01d97a4dc0142cf56a88e6827e2d"
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