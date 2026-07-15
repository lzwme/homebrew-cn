class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.300.0.tar.gz"
  sha256 "9d3ca93acd84ce8af4a9a9683656d3c0ec96c852872ac6ef9a11dd838fca8b41"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6665da6ec870aa9c540cdcaca6ad76e5f45a928cac3c2276a22fad69e3a2c3b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cced86a674304af78057b122eded6dd973e9c6839e9bd1c91f3160c313b641b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6060ad2c89b63dc96ed900384b12552196f4ba5db4dd9c2ecbcc8aa145304963"
    sha256 cellar: :any_skip_relocation, sonoma:        "577bb138c86d745e213432145f9f87ce0c57e46e4d8d611313711d3a7da844e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbd290fe00e3e12f9fe6ffcc00f348c58071d743d1f7aa46f2d63d660f15f063"
    sha256 cellar: :any,                 x86_64_linux:  "d87ad6704ad2b6dcda45d541a6d25b63256988ef73b0a17b5babab5acf64f9ff"
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