class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.346.0.tar.gz"
  sha256 "1d713a54c325a4a28b9c18b5b7259cb92c860c4f1cd304f192867871cffcced4"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e593f1a918c61113568dcfd1898a527e8be061a9078f4b00a9e8c7841b657d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1185ee69a5a03385c2020763b8f122170873013606f2ee96056beb11d099194c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "020f680d864ff5ad33f648a2a7c8ecba7fdc628c4679d2b1f62de38816054402"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a35c782987f54612a98d5228d12a7968b5f4b4be876deb86adca00d5a4b33750"
    sha256 cellar: :any,                 x86_64_linux:      "53026bbdfe1cd3e043d149f4be47a0898e32b2484e777966b5c68bd37798ea4d"
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