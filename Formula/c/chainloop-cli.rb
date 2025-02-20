class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.169.0.tar.gz"
  sha256 "b345d1d4c7a950bbed69ebc218918ce080757055fcb94976db7833f5944e96b7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb88ff74499990238c93d2cb8904719ac894b90230cf5e7596993f30fb987968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb88ff74499990238c93d2cb8904719ac894b90230cf5e7596993f30fb987968"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb88ff74499990238c93d2cb8904719ac894b90230cf5e7596993f30fb987968"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd1b24ed9db9a902d81f563d4fb1519fbc461afc182a7a4bebb14ad4608625e"
    sha256 cellar: :any_skip_relocation, ventura:       "93427b7621c415c5e7478a01c2ef67f38fdc440023885b0ce1b85105561ad81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b5dc5cce09f9763d959ae04a31661ab98e3e99bca738ae8b9882700efab0c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end