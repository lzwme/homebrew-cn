class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "3a86fb9060391b55e18ffc848c56f74311ad8901f68280a1bdd600f7fc4581fe"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25d2aa9c94183b3c83bfcea24c276a84bdc6fd5314738ebddbd02e03bd5b091d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d28f5fce26ff6a87267e4cab4f6e17369ffa33810cc60941bd8643c85cda80db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "010afb8dfe7c85ba2ba733227fcf3988943f0b43e6f631ccf4e6a1996a13fb99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0c6282b56d648bb1998c97eb8523a01bbc5d0d658b25252c79be2b299c68f54"
    sha256 cellar: :any,                 x86_64_linux:      "1aa23c6d5bce034daaed28256fbcb2c55dfa65c98e26a87d8122efa594723dcb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end