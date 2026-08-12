class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.314.0.tar.gz"
  sha256 "e08aa0db0c6af0f98fd4e104be6af703e9eb99f32601efb91ceee8834360e87d"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3078ce3bc247ddd839b83290dbd3531b101f4ec0b9cd1cd6a5e022ccab11e1c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9718573be4e30c5ede520951e0615808be9e97a017200c0cb9099b9962fbb36c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "295f7db22fce15d5a936219fec9d9250b7eeee17d1952856c318674efa17988f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98c272e4cb0e84a631d24d02f0dfa9af5d2f3f8761f7b4c4668ed253744ba25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84a6f07c1cf549afef5684823a4b16f856875dd7e3da775eac05b70e4ff9d51c"
    sha256 cellar: :any,                 x86_64_linux:  "b9c1589280a9ea39915232c21c008c8aa1f70caec941304ac3932a0aede361f5"
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