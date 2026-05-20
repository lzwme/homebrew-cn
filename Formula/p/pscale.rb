class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.284.0.tar.gz"
  sha256 "75bb8cf8632a0badb6d98edbf091c17ad437043a0c2bf4bc34d41119398e281e"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82bd020f7c8d1b0f9ae54df0e85d38033f8176dfb44380fabd33f3d6150b5cc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6975dba0bc2cdd0478c156ff29f4830da3319501ebb1ca961acc882e013adc07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42de328ee5e87fdfe28b427b5f91b7ae654ba115fca94faa2bb51bbb4c55c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "50b5bc1395add30085b7fd9a0dcc0246b18c1d2ea3982c06dfb540ea43f15f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf0e9817a12434819d06e5721c3af1ed0c84b2c3c90fd63e28f5d50179cfc212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e117f591ae6d8f12dd92e1113acc1e2e811093231688cb8b6d803322c2100ee9"
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