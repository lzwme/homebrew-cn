class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.274.0.tar.gz"
  sha256 "3871546bdf7ac94d3649c58e19ef7305251861713e823e31ddc7992a417822e7"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36698fbe0f5f5f418a8f49dca137f46a9a25ec270f7ae6b9f74305c716f97343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84b6253518eb34a9f604f3691179c2469eaea83496b14043ee97129a5e259bbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253947c3c6bb7ca9444f3f26ece088d2930d01124ee2cccbf899cd22464e3fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2ede9bb08757b40b937df16e2c8bf01ee4cdd79ab0656eb33401d60380bff37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded0aa02e29879a764ea2abcd4d56c67f773bd45962684f1b941d3ca7a4b2cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c61a362792a21ed252ceaf613bd7df9340cd40b4189250fd6e444e96f3cd7b"
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