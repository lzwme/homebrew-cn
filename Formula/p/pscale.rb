class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.264.0.tar.gz"
  sha256 "897ffcc6bd61f0369612cc5b1cc5b73bc383f3f9a512fde6fc3e5f9da77dede4"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26de32b3d4ab9fba74853eabc4c608986e79aa93dd0b6556177416d7e9743eb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac79f7eda2fbd7cf0cd4602d966c0530fae4814f42bc2f153c829e37d939ba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4c011afcec2f64550ebb117abdd9b8fca90dea67fbd83aaf8bfcb4422bfb22"
    sha256 cellar: :any_skip_relocation, sonoma:        "c183effde86624b6e6a7d56147f7ef58243c3e385892d5dcd9d7077659e7d14a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cef027f9b599308de19e30489002fd074e4a1e7e945bbb7019d23579c37da635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d51bdaddc18b20566ec0562a0966a84d5c1ed4d47d30de029eac85ff2d7794d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end