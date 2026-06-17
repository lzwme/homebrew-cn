class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "aa5bd2d9f274ecb40d54260096cca63f1b2c9e8e39a537ef57d0ffa42225e4cf"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97dae53135be6ab8034899be194bb1a7d100236f668f7aa499ce17522c8dbe0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b06f5d19e950bcdaf1caddd4b0704b13601e5b3206322cd218e36012d782feb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d2eee27e514fd1bb0a9e9c1f9d15aae2bd9b5bdbe69b96054bf1133b80179c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b98f7e2bd9e2cf822f2d2bc63b5d7a66e5916081a5094fb3078ddcbdc8810445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a8afc506c6fb5bdde4c3ad434310d0d99dbd71055147970d72b667ea8f0ba3"
    sha256 cellar: :any,                 x86_64_linux:  "8a29c975d6b5d960230a65d97444885f1305e8e3b2742c74976308e3dc0f806d"
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