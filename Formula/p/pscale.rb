class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.315.0.tar.gz"
  sha256 "3277cfbeb97ca2cd2467cdc4386723743416f9cc4d7e0521c2da9ecb63198230"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068b8fac6e4a7021d8e03ba4f922214f05ee80b2c2cee8fbacca79639c615bda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee0d2a80a4a842c9434a9ca0a0b633a33017a0998ee205e0fc59237cb6022e53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348f99a2292f275666faa447e5ad43cfc48e55351dbfeda0935d0f5d253dbc08"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be774d3fc107eaf7b27e14dd7844913828f78a74de4abd42613bfbdab009ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ff9da0d20537fc146fa838c59f79c6ca863787148094b9488e4d75271c963f"
    sha256 cellar: :any,                 x86_64_linux:  "a2bf748fe11c4c7e2eb27edc21e3fa9e37c43ed948158ae90643a40ae22c3d9f"
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