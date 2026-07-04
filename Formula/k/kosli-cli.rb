class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "42e986f3b0b4a410a5c66e11fc8cf4a25715516ad1b2aa374a900f7edd0de284"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c1f5a9c86aa9aaf3e231e440da3e9e23c99e27a89b4026511bb8f3f701cf270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc4ac1a8640ac5ccef472ceef96ea49621f0d1f9109baf012be40d42c4fd6849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a9a2227ee057875d3679879a2a5bd67b4bdc8057c8f6f415fa5d3e15a333c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "44af7bc5baf64a3e0d65d2eba0a83892a7992abb432af7c8a6b8af5c1507063f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab422caa74f326258efc3612b560d9449eaa27dd5cc5d983c3f645e7f2affa72"
    sha256 cellar: :any,                 x86_64_linux:  "f81e7faa7ebc2d5893ae0401e9c5983ec00aa35904f14ca49d54d80a0f660432"
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