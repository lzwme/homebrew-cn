class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.319.0.tar.gz"
  sha256 "3fae6dbf4fa516145648efc77baaa7f8ff2626b093d5926ab739889893963dda"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b02f1a4304083d463801f6a3d92911a82f351ce9899877acdadeb5ce69f66955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a6a1e84d91ebfe26dc746a0a5c353c1db10511a385859fe7dae0b61b38b2f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f4c16aa2d9ad435c7be2a6479d52777296feb022005abd996102be4753f6e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "622b165db41c3d8d6519bf2c2ba1850f4ffa74eff3fb1a65f20d5949096c8de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a56a00bed30c1b4202105dcbe0eac0a049b0c27666aa524fae3d5d6a0c6f4f"
    sha256 cellar: :any,                 x86_64_linux:  "a28b895306d32f7e72d79c7ca59edd358d18dbcfdad0cfb8856d8248c11c7d73"
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