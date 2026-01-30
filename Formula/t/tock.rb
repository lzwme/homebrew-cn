class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "1383a309cc08bb26a3bdf986c220df0b5ebb639ce0c72a9fddc8de50a3dd2600"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "902bc2cf747317d769988930338ce8c82cda4c89d51005c573209358a2d3ade3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902bc2cf747317d769988930338ce8c82cda4c89d51005c573209358a2d3ade3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902bc2cf747317d769988930338ce8c82cda4c89d51005c573209358a2d3ade3"
    sha256 cellar: :any_skip_relocation, sonoma:        "768ce9c5c9eb3f1fb3de384fd67f303fa99bd0227bdad2d3db01edf4b39bb801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cac373ab4062bdf4105047ab20f31655efa26cbca1a85004bcd7b50e08b42313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410d47573c570cfe25de4378e5450f7a52b29f4b3b960cf2f905ad467a010b26"
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