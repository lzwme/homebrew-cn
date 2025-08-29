class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.254.0.tar.gz"
  sha256 "a93453918f212a3d1c42dec3d629b44911d8ae4adf3761e3bac114bb0ecfedd9"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7606f949b01b7ce30412a3d87ac5bf990ef22025e34c25fdb18f5a12529dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c772244d9005f47b53c1349b01b5f39b1a34e57a06a87f4e2e16538aa1b618e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b31a249ce5b5d17d9bde14c454492e13cf10f757c89841657d782a5a11142427"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b9fe1757a6931f7b4d77101297ca94249937494c772a3d464e647ea86a8c280"
    sha256 cellar: :any_skip_relocation, ventura:       "c139721b598b3107768328df5a049bc770a926c2a83564e468554e4a0724ecb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b664da5e15f0688e29232871ed47a4b6bb1e74a9df221e400484911d08908ce"
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