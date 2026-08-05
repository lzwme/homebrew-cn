class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.309.0.tar.gz"
  sha256 "c4775414c673356d9f68496102bbadc469d716c2b2e227e6689b87a0efa1fccf"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42ccf74501fb80989fbb13d75b4bbde0dc69568c150046926b5f743e1ce546b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8224498c16a5b6bef88061f22f5260485eb6e9cf0eb09ffcbbd144ab8dc1e408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe90dc1bbb293c32a1740cc000da2d9b0e749dde3c241b86f7f45005b3dc3f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "330cb6259374cee95c5be65aba23899d974a07031f257262c4a82e5b526589af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d193b7dc7d8b7b384e7d353273ad11eb3db21f8e2cbd31d514763398f9c86ed2"
    sha256 cellar: :any,                 x86_64_linux:  "aa3d83bdfef2abc28a0e1293f6ef7ef2ceec68986a379f9acda9adae58f1fd3f"
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