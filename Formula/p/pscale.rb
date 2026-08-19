class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.321.0.tar.gz"
  sha256 "fdb75eaa18eac8dd75fc2060e61e3081cda85a1ea01332817cf37fd4a61587fb"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c7ed28806260b0df9b67be28127421546279c9e2ae50b7b047957ba80f61fee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f62d4f47185a74b9a727124881bfc99f39aa13a1ada40ee2f0d5839ac013ade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a10db28500cf23e413d0ece618d1b05659aa7cc19b076e7a541352b1ce8def8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a56752d316b65815231768066bb34e33b88038dce7bdd884d8453a0868d7289a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d23e60b0e747e8d8b99cb9335b446c9ae55a089fdf77578421708b75247bcac"
    sha256 cellar: :any,                 x86_64_linux:  "12b2f3a211eb8320802a9b7fa6c56d95f09c81f271a29c20ad4712ed88f2d625"
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