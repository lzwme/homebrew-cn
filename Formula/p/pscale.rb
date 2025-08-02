class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.250.0.tar.gz"
  sha256 "aee8277dd6aec5d3864b887f3fc59a0d19a2878ac1496e462ca6f5438de7091f"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6255e76b801347753de62808d2b4db25081719f994fe8127e7f2ef15812f1990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221b5d2c1292b8ecc25d0c3825dd409afd39e2273eb60b448cf61b5ec0e27872"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a03099ca77568ebb2b42c713c6523b42f9ec5726045a41bcba1f06870267166"
    sha256 cellar: :any_skip_relocation, sonoma:        "41637c0aaa67f15dfa83f2132d12663108ec5a01337db9ad8ac678fdb2569587"
    sha256 cellar: :any_skip_relocation, ventura:       "53803b6446bbf1318c7345aa34fb7a465425a8d949a369fe7f70e7d65a6e47ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c441c9ea3f525931d36337cff4ff2c88f858c53e65720398258a25001b4f130"
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