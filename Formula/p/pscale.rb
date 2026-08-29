class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.328.0.tar.gz"
  sha256 "aca0b83b42e6cf6420c208c383a102183f5b740ffd76a9be52495f00bb692491"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a8f4471d8aeefaf42a9aa62616590f40d3b28ac6d85a1611bdc27f684954a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "312714c76f36da115adcd177426ebe007f4ffa492f140fb737b5fd3d8d421990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b51f79708618fe2b45e91f47cb6cbd1e4ae05d40417acabcf256b3b7c1e39b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d3d2d359a1a63cb02d13febd15f231c40b64ec63613b01cdd9ae8060957c94c"
    sha256 cellar: :any,                 x86_64_linux:  "d58e3816e57f515aef7103d260f7cc6c949d389d28384e8feb6ab0428ddd2984"
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