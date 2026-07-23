class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.305.0.tar.gz"
  sha256 "610ccbfccf47c9602d7fb02af82f9ae7b09fede25a47bd64dafa79af0a62aca1"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14159a7d2de1a8fd74be14ee064713775915808f2988e5493ff30bbb9d6d6212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed0ca93be2b0e749e4e638741b79576a4f0498404c1352654f99e997e88c2d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f9b53b8298aa60f5c19c07ae3b0fc7571616f11f26280f342a5815dadffed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c16bdbef91bec7ee0371b92a087b2ae902fc744f1bb44b20f75e8a77379dce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d70e089eebf9ac7d69b368c380803188af3ba5c35c9c3491edcefcf5687a5ac8"
    sha256 cellar: :any,                 x86_64_linux:  "4c7b5c3514955bbd1d2bbe8dda9d8fff6d13ff850173a721750ed10fa01d92f6"
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