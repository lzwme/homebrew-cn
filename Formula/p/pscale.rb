class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.334.0.tar.gz"
  sha256 "cad86698394fdff78672e4078fb57a31dfdb11ff599afa6baf844ebb2fccce53"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e27dcb141775dc0bec7cf703d8f6e3feee414b021c945878d774b5f761c7fea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbfab4ed285863ffa65f9dfb9e01013b559619260baaa73da1608751edf9c9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "890dec30818f8cf49037f112e6ff0651f093928c59a987bc340e3a7702cbfd12"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bad87fd63fb7c7400b92e20bc218a3c94da9f957c3e7ecf00d0ff7fc00a3a3d8"
    sha256 cellar: :any,                 x86_64_linux:      "f6f0d2c1a11b01c904411cba702c98727d0c6133b52d22f4329f004c949c3928"
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