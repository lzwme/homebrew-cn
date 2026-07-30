class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "6836018b851b5d04e6a458560f1c75b4a162793415de864e88e6467076e799b7"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcdb51b0e9acf8943b1e208c2e9672d493b7145de00aacb3f91b7c762325d435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd86baf7873c56a161a10f48cdd5a70ec6cfffce03b625dd8763fed8b9c0c8b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9f7e83184fe5a2b4bf204c4429e2623fec03b8db6fe094ab214605ac1fb7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88eb374241662aab62e12d25f3ba948ec4cc0d87a1181fa92ca06cc55e5e2d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "207834ec1d02ae4d51ffda2b14835cf838659139f3f3ce5aa1f51aec4523a323"
    sha256 cellar: :any,                 x86_64_linux:  "2051b82d0e93e488d95edf1dcb40b78797f52fd10124eb422b73432713e0c3d5"
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