class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.343.0.tar.gz"
  sha256 "80ceb4f2beb320b69fba31ff2149266a4c3989cd386d5dd436c820afea5872f0"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ca60a688b80883e14c835016f22a88aaea70965e592efe0b5cfad1a17f8675b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff01958aab90af6a639cf3a35af6afadf5cf386e1fbeb82de2b8292d3300ed33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "514dace2f5cd802acedb26b2bfc51d9786273a90b2a3ce8b4a110757f59903d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "550edba4f84ae80cf33e09f12e9c2af442244251324718d8eafca5dee8adb4d3"
    sha256 cellar: :any,                 x86_64_linux:      "2531857c2e4a66497be70994e88f467abcdbe3297f90ac0ec15e90f3acce7465"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end