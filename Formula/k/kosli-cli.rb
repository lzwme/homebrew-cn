class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "07bdb4b6dd1497058bd12f064da3fbb0ca2e14d87adeaf08387b8d5041d0b72e"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e04c2218a0b9f3578862a479c21fe4f48229ff770cc70d553caba461059775e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d09bef3364ba4c20bd92f0e27c94425038f2d1351c298e827566894a1e5fb8d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738be01ab47b7377640c4720ea42e550b57f4a39c61881f68af25232d6aa5ef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2766b998e66f5f9f900b1f37b64a65878fb3c99fbe7ff0f0cdbaffb6214e3282"
    sha256 cellar: :any,                 x86_64_linux:  "9c47c311e1fed3c3307c2c6d069da9964b15b171111641e44f5d0dd45f43a5ad"
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