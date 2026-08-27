class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.327.0.tar.gz"
  sha256 "725230797b595101e7a40ba3bfb2ed382d167b45a2d11e0c10eccfb80505fac9"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "233aacab8d39ad597c6528fe908179a5abc11296c7606092fe4b2ef541855cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ea02267ab6ebe794b3a3ca110598e40dd8e08aad2df8df37c87f4a6a5786b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e510ffdf6981c29e36dc7bdc7c114f28df820ab3daa9549080bea1bc30dbfe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3431a3216b3d49fef88f0302733daf26778ae5e82ef5868d39962012a5b25565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ee975268274577ed33a8cfe143a903364639e424bc7003e0f8c305e3b64bc01"
    sha256 cellar: :any,                 x86_64_linux:  "2345661ffa06ef36447c3c454a68c84e408758e40a03672e4bbdcb709563775b"
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