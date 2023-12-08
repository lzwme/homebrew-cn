class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.16.tar.gz"
  sha256 "429b2e57267910df5033ca5827f3b4271daf529a3c393fd49c820df00b7500dd"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d653c4c2572951580bf0165c5958c6765196e80f3c49e4bd86a17f2613f6fd34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02231ac56746bf05e6d275995b671b61ab79d7792150eecdf370a0f949f40bbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eee438877b9597c872ba9f483ccfab65f0f23c2e53a8693d8e4ed989f0fe86e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb7c3e8992097e01d8a340d71f22f1e251d01410d6113c053fbd4b243760fc51"
    sha256 cellar: :any_skip_relocation, ventura:        "3166f5519deba60f17e032efbaa0d153c21e364c3523a21716b9eda55d5e4926"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5fb8b17e11e105bc96bd4015a29bb6adf099cfe9d2c0775ccab53429b71aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818ca3704a616cfee5920959aff5a4b34959936bedb50d58284f46700922a5f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end