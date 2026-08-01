class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.3.tar.gz"
  sha256 "cc6c51423c08da65ead4c2df82b34374c4d1c9cce9c3b149009a45c1a4af8fbb"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b5e03c17e214a02aae137af31551f5406264eb5631fcdcebebf6ff6f8596d8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "205710eefe07c1b3216bff91600b3c912354833e7676995521128198ecf41d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780159c934fa9bde6ecdf74d05d336b79de4eff6888d920946fedfcd3ecd9b57"
    sha256 cellar: :any_skip_relocation, sonoma:        "bff70a2caf5694f9612a56733c0983b0a37950bd25cf048802b30b9558fefa4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7063fe1bba1e9a1a1e9f02043ebb37494ee10275eb3b284ce89094b2d788ce21"
    sha256 cellar: :any,                 x86_64_linux:  "313e36c8d8923f61afce69bd61ffbee8901f1a56f030e4583d0f706363e248b0"
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