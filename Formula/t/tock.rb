class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "1b2a48af5e3b46f467d02c786addc0d59e7f451436a207e1f65c6298750cb4e8"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b53d915469faf385a1193505d417f25d76fd006c235281caacb5c0731503ae3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53d915469faf385a1193505d417f25d76fd006c235281caacb5c0731503ae3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b53d915469faf385a1193505d417f25d76fd006c235281caacb5c0731503ae3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d5ed9f813ebe6cbefbfb2282877473e741e1ef24d422f094f90678bac8dfd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90cc20bd980817f01303291373cae303f41f00c147ba8fb431dee5a18b45382f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa47edbd27574767174d7bb21bc435364cc5e0964167aaafd22e08a77cfda552"
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