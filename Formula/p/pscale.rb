class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.273.0.tar.gz"
  sha256 "ff1b586220fafdd23deac383edceca76e3d954a049b775e74dbc020d4d4f24d0"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90951a641e482933679311760400ead6ed23868f65d6ef54932d21bf83013a12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08eeea36a927a1b5ffdda46dd4f579f39b71d87654ce1848dda0ac07165aebc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deb36c1273fd9c24489de786b6be400522d34c76d63c00331f7e1167b2d90743"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eb42555aaf1edd509557f32a73c8218076a19e16542d8250009eff924bfedc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773c9b6af9c82f5a6ac941c1c3e0afc8a0645b661334df2d086d5bff8cba33f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb69fb8132bda54027b68a113af7641ca539894d694100be204eea79e14a92fd"
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