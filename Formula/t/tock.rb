class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "00d154c8e400593a154df3f20aa988731d782cca3ea40a26e13967b1ac3a63be"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8953c3a7f111eb0ae9a43396fafd2cf1116c8dc1d81265cb37a136f5c6a7df26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8953c3a7f111eb0ae9a43396fafd2cf1116c8dc1d81265cb37a136f5c6a7df26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8953c3a7f111eb0ae9a43396fafd2cf1116c8dc1d81265cb37a136f5c6a7df26"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b512ab8931fc37087c7ab70f5832c0dbf95b3e0081c7cd3bee5bf1597cd6d15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0976271698bde4ba1a69439aa550e7ccbef4a2f2a1478a85b1a2d4cc5e7080d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d476f4c2e153a8703a7dca2bf148cd9100b4d68709bff28ed4d5e9b6be682647"
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