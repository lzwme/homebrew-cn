class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.317.0.tar.gz"
  sha256 "1ff5a77b7f0543eec38974df2974f79fa4dab08ffc5a836d7b22883013f5d424"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e39873c87f93fa25e06cb863f4a45941b2db2938f31ce5b3963abe596f33923b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65412081c0fe4e501d40f9a8c44d886df621914ca88ba533b0754739ee4a1a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf8c615c5864b883a39bf251cc146d6465ad027cb3c1f7e1dbbf30a6817ba39"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d06d56bf88edc026119810117e185c6bf4c4194c199cddb9345280d0037c301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02fbafaa1052ea5a3728897322ac4d530a1ce2d4d47266cae5e14ccd71157496"
    sha256 cellar: :any,                 x86_64_linux:  "2beea1517f116be95d9404ad0e04a5bc3c5e9199ba98d81c012d7ae707f929f5"
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