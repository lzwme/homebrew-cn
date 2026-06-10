class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.289.0.tar.gz"
  sha256 "2f5b1ac9b0424f8419b77138aa4e7b97a42bf8a99cac2e10cb1a12d27fa8a884"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd6bfbb5bc342c58f9c287bbbd437ab434771bb3a3e932d18e39bde647675cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c76dc7340233e4e9e6c7fe738088b1a7fd68d5621a4795ca0eb0393214609a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66bb02c33097220a3cce1ff437163941379c76b501d2d52d8ef4076e5ae18253"
    sha256 cellar: :any_skip_relocation, sonoma:        "19873333daaaa738feac3080d67ba5326c2f24ff423431593796d475bf24f3a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7b19ee1fc06907556d85795abfa9ed82150697611ee88643aa7ed1d128450a"
    sha256 cellar: :any,                 x86_64_linux:  "93e4ec0897db4dc982bee1347bc65dc548efeb75e3c95af882ea96daf0ff9e4f"
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