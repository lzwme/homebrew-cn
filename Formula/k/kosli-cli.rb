class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "9594efa709ae3d10d7e0dcadbb432b47824af04969704a369e71f3b2af2ff389"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7aa71b1278aabd1213fc429fffdef71867747728e63aa426c456c5bd2ba791ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "538f9d15ceb9b573c848334309b3e783d2396f476cc46cc1f7341b2d2b5325d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "189b4b941d8420e6bf9a8e72dec6d2d7a67cac75013a3605a1bb8b99bbf4ba8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa14132dfd78fda1ff9e299029293db0f7a1b05244c77e5ef29c3860415fffc4"
    sha256 cellar: :any,                 x86_64_linux:      "7e69fce52c6aca10094c9bdbc7eaf5638134833acc84ebee040f944a4b096ced"
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