class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://ghfast.top/https://github.com/0xerr0r/blocky/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "9328c83aaecc858e4597a9eea36b1c3c01aec8ab4ef0d61c137748f701599531"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f1b4c03b378da4f8ad2e7e4b826c3ba105d4ecbe5917a08da35bd502f967fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1590a74987d15e7ddd38f54ec095ef0609ca1e04070304f602d1b30bc8d6debb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8ad5e96ff795a5748231d315b23b3a1e8361903e094d3ad5e063745c4d14ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "118897a3feda3f39cd721b29ff763598a80da86dae50d565afc7bf556a7682e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78bc29a1ffe45567c11c036ad8d8a8df2d9a6f90d0e997868876f1b7518208f2"
    sha256 cellar: :any,                 x86_64_linux:  "a7c366f12280be074d9d8ccb4fea60251498c2125c9dab756e3d0ada89dc348a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"

    generate_completions_from_executable(sbin/"blocky", shell_parameter_format: :cobra)
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end