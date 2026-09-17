class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.335.0.tar.gz"
  sha256 "d93e4a1ff4c0953a4b23c042de3e69f8ff9bf8ad74885fc2950c19b39c53ef73"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f5e2818fcb57a931f7010dd1eace395944a9bd6ce04052ee000304841becd36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe717335a2d09e701b14949f864f54357523e02d12f38e417018e356b0cf7964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af0d0deac7884d67f74880a758f3c3a6d659b1364a10c97b8930dd8f7b2ce4eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3735cce1ea4b0df10f295f2ff54c0866ad75d454c10c53d404442dac41120c18"
    sha256 cellar: :any,                 x86_64_linux:      "99c42954a3eda4bb599850accdb85bedc64cb89f83e485ae3343ea88290e28b9"
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