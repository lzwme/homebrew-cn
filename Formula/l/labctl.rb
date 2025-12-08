class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.53.tar.gz"
  sha256 "cd337e0a10e88f5f37e562d77337b2f3dd6820ce7ff72c38e0218a0111cc1d1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10c953b430eb4d99f8a504507e9bc323ef2045aaef77c847244bcc7d9fd98cd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10c953b430eb4d99f8a504507e9bc323ef2045aaef77c847244bcc7d9fd98cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c953b430eb4d99f8a504507e9bc323ef2045aaef77c847244bcc7d9fd98cd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "103fa1cf989cdde12cb00c5843ac97627d27045447c72626401e2d619ccf1137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68985daa4091ebb1ce8f23b0555ff2544f6744d49f08f5708d767811323d27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e19c15e103e1193e62bd6987d3470a4c2f24080bd7737a8fce9c63c1a5fb883"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end