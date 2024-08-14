class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.16.tar.gz"
  sha256 "d0efa2c5e5d8ce1989fc8c07d14f29d8294736a628ce60560e1229287215b73b"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37739dc1d0cf8aebf13727e692b186a7918d034c1adf13a19560ba4ad4011e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af87a6b9023eb6f8635468c8f9727e12da66eb444a656e13a8861c48f1895d2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d87691ac7ca415baea99876c8c6edf4b6a0bcbaa12611767b721e3bbe25a417"
    sha256 cellar: :any_skip_relocation, sonoma:         "b48e1d3587f112947058847297ebbee93c2794fe98eb825905b080724beab944"
    sha256 cellar: :any_skip_relocation, ventura:        "2c141a036bffbcc889c718ccd0476982634115309d30ba44b3420af93e66ded4"
    sha256 cellar: :any_skip_relocation, monterey:       "9e121af55ad63c2a06770ad4debcf2a14c21461c7855dab979dcd4fc4bb72253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8b56f7da205be9bf88f17d5eff1a8ff9ee793ddf35388714d8b05d346f8c1f"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath"pkgdockerfileembed").install buildpath.glob("cog-*.whl").first => "cog.whl"

    system "make", "install", "COG_VERSION=#{version}", "PYTHON=#{python3}", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    system bin"cog", "init"
    assert_match "Configuration for Cog", (testpath"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
  end
end