class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "07885c40c34d0d4c3932f0fbd5a07e59c1568258a21c0c4ef2153f1778c7bee1"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0dda848f3cd24d876684ad6c331d05e14dcb3a0d9bca08d362f3b68584e38e5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d846f0810f5564ede8b38efe1999e682d4478fdba5ce5249ecca511d321cb62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52c7e7a13694f97ef335becaadeebbd640f1bb836a5b0005f60bc7d5eefbee01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b56ee675a24e2530cdf363e3165c4bf1d6ada7a29daeaa21457375c8e145d9e"
    sha256 cellar: :any,                 x86_64_linux:      "577255670de423cbf93897c0172030dd3b37ebad011b90553cd5269f9a4f5bf6"
  end

  depends_on "go" => :build

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