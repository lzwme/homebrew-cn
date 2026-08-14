class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://ghfast.top/https://github.com/DopplerHQ/cli/archive/refs/tags/3.76.4.tar.gz"
  sha256 "d190f2d1cec27cb120b705b10adac4d9b49f64637bf53b521ded906831298559"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4863cf37bb2b72925ac5e4bec255c1557b69a7d04b9d7541b13a8e3db2d0517b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4863cf37bb2b72925ac5e4bec255c1557b69a7d04b9d7541b13a8e3db2d0517b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4863cf37bb2b72925ac5e4bec255c1557b69a7d04b9d7541b13a8e3db2d0517b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff48f9ea42b9f0bfcbc2baf4c08a571f634b23e96c6ba4f09565d86759d01cd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "663aceec6393495301e757559346f984da6164e7390d88723ebce669ba653528"
    sha256 cellar: :any,                 x86_64_linux:  "b267475789f429af8ebcd349ac495893663593d6cf81242676fab31dfb57cde9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end