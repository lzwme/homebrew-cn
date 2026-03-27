class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.277.0.tar.gz"
  sha256 "61d7741c43baa597e8d4fb9820d32c30a28cee5f767305af538ed6ec17961e43"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c13c726bf40f06df8b4652ea4f50d3fd837a17dbc735f1ae164d897284747ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec08c2b8534c9436e3b81495f1991011ecd9e348bd3865a10cc0c530bd1588b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eeffa284e95f45922bdd42c7fdc175a8474467c2b693b73e71f1e4adaaf7fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "987071d8a03a6dcf110c40ad41edc034524d00ee21d001e41f511c863dc6ac78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b2b33e0a77bb39a4c417ad94559d8ba2bb6e2676b034d33a1b06b365fcd075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c81c70bca76c4712e049cd3559ce3e5058779b2b02dd7dbfb249a35fde388a"
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