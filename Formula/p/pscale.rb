class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.332.0.tar.gz"
  sha256 "742f16b922851c91d7c5e3a6207046cedc50d947faa33a8c876b5b86f2f97afa"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d81deeca2fe34c7dd3490a040fa4e45097b57782d431b0dad4cceba9fcbbd89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60f6fd9c3b9dfb7c8e98d043566e9206fbf59fa9dba34acb49ef37e2506e08ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f556d9970ac603284555adb0a4c2c2c851195681b71237a173c31691508787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "357d1a786c71621778d7a6dbd75e190e191cc7bab73584d9fefee3705783bbca"
    sha256 cellar: :any,                 x86_64_linux:  "0457c4eadc9c32174fdd8b9e641765fcd56203db4e3b8e67ecfac9308542fa35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end