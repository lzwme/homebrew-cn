class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.330.0.tar.gz"
  sha256 "cc80ada8f549ec72a95073ab5b6e1286ff67889a6fc1aa581070cb070c7d17ee"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e80ebab455488ef5111375bfdf7989907e00fd91f64673f5a79654238856e99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4e25f6a1332936021bf35d7cd7724e9516a7364f955983990d1727cf6b7bd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d841d1065b1f8e84c2eaa9592297c1c21e449fd1aed2a2b69a798004b2b472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91cab26b6c1a737d3157845159c28264a596f2d5e7143c322ab56add9c3e61b7"
    sha256 cellar: :any,                 x86_64_linux:  "5c890cd768ef1576a08d0882361b423f246d3b0759f6188a003e9d90b2432cf6"
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