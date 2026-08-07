class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.312.0.tar.gz"
  sha256 "e35e5cd239d448739a38ce3b31353745178b70da097ffcb2868caf1bfe1ca659"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1994ab34e3ef819b8d3216c3bb9c8c7ba36d261cab4b1d00cbbf50513226bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "974f7a9e10b48438702e90354970cf9e062104a94e1ba7cb57d8f05b554ed69f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab59c9d35cf1b558c2beffed8d1ec58a0e0bc665b71bbca4625937654f36680"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded432504c13fb04185478f2c4d02d38bcef1b22ede46eb48c947c18bb5ce55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4b31efc759d43d844dae5247d6cc95fe25c04646758591a27c0b9216026d63"
    sha256 cellar: :any,                 x86_64_linux:  "dca07a3c3f2b2e7b16a14f3985e522f0f0f9987c4aa1f7c9b07798a1e13c7b28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end