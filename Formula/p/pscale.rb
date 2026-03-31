class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.278.0.tar.gz"
  sha256 "f82c97ceef64c8d31c64861b98405271aa9116f4424468b09879d9ac8b280db6"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "914eb91bfac3904e7dca5a6fac026c94f94cd819d4aedd17be8a76dff42333c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b4d55d7d1b2f91b5229db83132729e3117d84d5c22eba13289144b646f431f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21a6f1620fea926d6d3defb365d6ea46c1373a39e1a31fe98f090abb46cabcce"
    sha256 cellar: :any_skip_relocation, sonoma:        "482304efcdbd48dacc27e0d2a2829fa75ef4b9531a69f95b95203b49f9720e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "264e7f9305c936918e4fec4fbcf2596c836587e7a57f35bb723a3b90145a620d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fbd204f8ef30a265581096a911c3f537249fa4035e669a9a4277d0377a97bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end