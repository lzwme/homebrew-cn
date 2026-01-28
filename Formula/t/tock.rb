class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "8a7c3a6c0b74d1f702eac5d510e757deefd6ec227e1a8d5eb7082b07fd32e273"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b16bf7160866038a00ce2ddcad2f1bfc50fdac873087f5dad00f0ba2e760c7e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16bf7160866038a00ce2ddcad2f1bfc50fdac873087f5dad00f0ba2e760c7e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b16bf7160866038a00ce2ddcad2f1bfc50fdac873087f5dad00f0ba2e760c7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f7e94f19b0beeee9a9b52ff83b0246eaacccbe0ed7150558af72ef0a7059d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06a13133c9fa21ef65ccfdb48c9165f771639bc6b401d4660b29f637f3467433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6d43da6de8e516fdfeeee6c64f834aa10fcc28e68e1f0df1173d6091d4ef14"
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