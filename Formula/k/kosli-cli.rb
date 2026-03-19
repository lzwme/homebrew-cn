class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "34fc17ac5c9eea2d7838e8a308e8798ea7d786287a567a144423a9bade43ce3e"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdffb5fa1e4cfddc9133868471a8ac5da5b73cb84ee1de57ff571d8842607e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1edb3ea2cc696da5a6bfa79afa2a131604bbd7fd89e4acca7f26d3d6087e4aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd9386a9a7ef6f2ab97435445aba5c2755a7e3fcb0da5202860bac5652e1d387"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0cc953d122788924a1e3b307f752c5b49192955f00d4f47510804630921ff55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694e10f0b81f583f0cf4606d12c1fa91170bae29865d676b04b860c1a114b899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969dabf07657e5e5ebb157a8abb0bba0a57ecf24eb3735b8c4d8d364d0796bd5"
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