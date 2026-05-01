class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "46d9e5cd92c49390bdcb3d78182cd592b9dd309f7b5090d0476eb2e2bceb08e7"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d59414453717ddfbc9188c7652848b814c6346fb075d713c1bbda42af8d8e43f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94c410afa74eea39980ef36ba451d4a2f1229cafe0a0c145d9aec7796c4e0905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac174c86b03b9baade8412365b3b51861abf53df0b9fdea0a597771507a8f911"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0d2c437f1574d44ae0bf21693f001cd0b6f004d340c3846d37167774a4c264e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e43d2cc07d6869b9771617f3b95991cf2d7fb531285868c8536c64146682403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe08c3bebf172fb2e55a1085a9d9e22d32db910012a82a0ca434894b3b7e78a5"
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