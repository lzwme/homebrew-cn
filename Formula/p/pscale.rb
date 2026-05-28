class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.285.0.tar.gz"
  sha256 "90e56d486b739420f206762891c3a2d22f2fb7a26ddae7ea3ff4b99d6101d041"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7de63f706a617287f3322d3d35b4ab53753dadcee05a65267c0c3e339976ba80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c354427b10efc709f1100a9770a20326d043dbd76d11b7380f81d0b2bbafaeb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af027be125c593c342f9e5ed4704dd8aa4b4e81d0731434f415ec0c4c52c680c"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e6bc431f1baf2d065165ef03171da31496f3b0aecd63e31c10d202717aef0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b18578f04e0cabe922521c1ed95eb410bd715271bea0f8ee17459eecd8a278ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3dc7d9f2aba435471ebcf0351388dd1e787744018c6b04d97eab5e7d7e544d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end