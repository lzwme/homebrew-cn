class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.252.0.tar.gz"
  sha256 "216950184a6420e6662b952d77988708bad17f597d6f70d97cf514198b10e424"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b898511aaa2246e3bc809f06edad50a30316014168564d4c5d885fd90e46fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57322d71fb7c9189d7e92877091763d68bed33a06a9afc2313bec007c3d52304"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a0c73123cc1e8a4a732cdf9689f1dcdc7abfca4ed29674609d175539f893be0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2682e8b55ec8ff92b735ffaecc8f8ad5362c5e863e6bf5360d68958faac98b7"
    sha256 cellar: :any_skip_relocation, ventura:       "8ff95c093c478e3b6e23aba70fe511866cbee25c4993a3077e884ff2934d0e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f0458e2663f039b7069b9220e8ce797724175cf967f8b270411ac317340187"
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