class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.294.0.tar.gz"
  sha256 "221da680d6482eb09e86ce83ef08510f8c2616ba2d379abb72502becab4e3687"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58b239648dff765126a7888ff8782a417d1508375d9f56e12b14e17e907e3338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "496efbe7aa281439a34a351271be36823d10d169c482e618e41b48903a81a7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad2aef0b38182a845e1c90c3604827da9db217a9f0755a7e4add301f3515968"
    sha256 cellar: :any_skip_relocation, sonoma:        "a33c13c9ee236d173fad136153dbc6b0cb6d28854f31cb7aab14c8951fa05b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be08fbe6fe1cb80cce5647dcb8113fae5390aa5bc20846455a4585585ccd6eab"
    sha256 cellar: :any,                 x86_64_linux:  "0cab999f632c39de33d5a16a64a035a5d62477823a57bf46cfed35a0b6c12768"
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