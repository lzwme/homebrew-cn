class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "6c5357ba4ebe00cd35f1f05685e1983e4f7f808a6f041dbf91302dbbfc9805f3"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eebf243363da36b745996240771fa6a299563bfe1a0236ec7f1ddd357d48467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eebf243363da36b745996240771fa6a299563bfe1a0236ec7f1ddd357d48467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eebf243363da36b745996240771fa6a299563bfe1a0236ec7f1ddd357d48467"
    sha256 cellar: :any_skip_relocation, sonoma:        "a47efcf7ffe1368c9aedba2b5430211d442bab5fd01b6035fdce97addb133007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad01676072d8bd428448e33ba3efbb80846a84cb3343630552509f28b899af99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "344302e1d8ff8d307fc1d2810a02f01237ce88a111c06eef3ee84fb5665b95e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end