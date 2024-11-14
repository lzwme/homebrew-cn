class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.13.1.tar.gz"
  sha256 "1b9130b5d251919b074a1a634fc834b941efc74d9a9e01003d54cf89aa5f0474"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9404a259f085bb1dbd3b627eecd8249d18f56196a23df02fc7218e35c5cdd2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9404a259f085bb1dbd3b627eecd8249d18f56196a23df02fc7218e35c5cdd2d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9404a259f085bb1dbd3b627eecd8249d18f56196a23df02fc7218e35c5cdd2d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "390b0ade90718712c621b272000fb5b31d680284a191185005c58aed5226a948"
    sha256 cellar: :any_skip_relocation, ventura:       "390b0ade90718712c621b272000fb5b31d680284a191185005c58aed5226a948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c04cc02ea62a78c198984c9f602ca331a5ab0e1eddbca6a94bb402a759b2352"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath"pkgdockerfileembed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.comreplicatecogpkgglobal.Version=#{version}
      -X github.comreplicatecogpkgglobal.Commit=#{tap.user}
      -X github.comreplicatecogpkgglobal.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcog"

    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    system bin"cog", "init"
    assert_match "Configuration for Cog", (testpath"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
  end
end