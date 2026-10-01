class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "687e66349a174c7714e89784341c1b20b3df2554f7799bc2a604e0f7daff5a6c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0e67d53b9603b8b06fb407eb20eff7410f84bbf6947d510ae1370091de67b40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5571e01ae3e8aa35ba756a9dd86780734f732f56489179041b69e6c0d11a55e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4168ca3fb811ec56c9065551626251aa616428936f8be2e8e7521733fd0ce9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c52213344ba447344d8b3797bc69a98e1272844310d83fa27e098ff626d83f0e"
    sha256 cellar: :any,                 x86_64_linux:      "471c7c35c26b66f94b401016e648e94320640ba97b4ff41b94849f8d107703f1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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