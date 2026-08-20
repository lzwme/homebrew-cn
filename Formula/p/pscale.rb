class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.322.0.tar.gz"
  sha256 "6a0a722f3225d2c24f35c735c992ea94bdf592f43ccd8488a1e2eb0e1671fa3c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "319322e9fb31ac8f5a216874969c1fc0098f7e87c2ecc272662cce575872dd3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b368879978727dbee62e9729ba6e9be1b67537f20a0b8ca99c14347437e0fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c76d67fe24b5dbb6a172db640e9c4b71dc452992246139113ad4a0a92693b0f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6651b5c802ca60bdc26d32b878dfa45aa73e190463516cbbb787cdf78994f425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06da8ac5fdbe3dd5ea6d1a88fca0adebc0e834b5a0d4a9ca993cc45513ed983"
    sha256 cellar: :any,                 x86_64_linux:  "bbbc67101cd2e3a8044ac78705553697eeb682a91f65d6496fcb3fcbb06e7e46"
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