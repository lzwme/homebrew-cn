class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.275.0.tar.gz"
  sha256 "89e2e82efb64b26e696a294501906472a5e953d65ea06384101f9e9988d9cbe9"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdf950416ee5ce8489a24a994f8a26b386decb0356e30708d830af232f5ab7b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee720204f57efae395117e2a7ca6e2cc5c5dc7c1fecf330b76912e843c7b3293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12b4f3db077f687dc93a3cc34250b9e02f4963ab491b8d168d39bd571d4eb8eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2771efa1c6191fa8b9387dbf7aa56851b2e1d565dc6d8e0d8782215c1fc59279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32baa759abc459c0fb955036a50221aab9beff0e5a3b06bbaf93e4dfc613a39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7316f523d7255452b89f909f63d182be5ff85610cd5f806986c52b2cb97501d5"
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