class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.299.0.tar.gz"
  sha256 "42a0b043de09b1a840039e427db1421579972c8683626bc50a055e523d9aad58"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318eb69958d3437c0093b25a6a215574b3ac4d9d5ad50952489a4ac4fd30342e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1b704cb324b1c6c970eceaa14b6cc88ba61852cb9bb8c829d16599d22981ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94752c88fb55a63a7b0b25f20012c2ad40cfab3b573f6ba013eb80f4962a7956"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c17bcba8e2f53e10d8b5b39fd71060fd86d256c40cc3e962507e4fc859e7ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea7ac00425c81accc928bf18322100853818a966a9a5a1f8701f4498f5b9f951"
    sha256 cellar: :any,                 x86_64_linux:  "c383080751105e69a39748ce60f22d0289b5cd1c4d23bbf213204c301e5c9186"
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