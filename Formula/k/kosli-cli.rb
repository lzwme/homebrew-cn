class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.28.1.tar.gz"
  sha256 "4436665b205dae75f529c8ef663d5e1c3c73598d88c45d1b42fcca0b30ce36b0"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8614be9f1a44bdb839a7310ba8ae77cdbcf4d816bfb001603de71d1285db3933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d322f19d69b4dbe8c91261cd7e372dbce07e994454e86d1d1a81e1d4761b8e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5669d94c519db2fc6c7ce426158d7209fe692f179a098a3ffb63ab90cf413d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "311e7ea30cc9a490a606a216066ed842b242bfced6de4666f81f17060bd7ffa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4226682a2bea3e10251f43abd83cf6ebfaa18763279835f42316516c9f19009b"
    sha256 cellar: :any,                 x86_64_linux:  "e3fc8d1b5dfd65626f3bdab5dc97ec39c178834d611fe8f651abd07e459c0e52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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