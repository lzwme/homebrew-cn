class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.12.0.tar.gz"
  sha256 "7e7aeb0eb560368e304f5ec6b13dcc6e7c8f10cdc08eabebd560d57c97a0fbdd"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc280ece559225c12c0d10723e65fae6e43c49d1a9ba3bbab65c08281f64e68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc280ece559225c12c0d10723e65fae6e43c49d1a9ba3bbab65c08281f64e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfc280ece559225c12c0d10723e65fae6e43c49d1a9ba3bbab65c08281f64e68"
    sha256 cellar: :any_skip_relocation, sonoma:        "1734ea7447760d62bb4ba067bf6744540daaf8979deeca281b04b3d3905ebb73"
    sha256 cellar: :any_skip_relocation, ventura:       "1734ea7447760d62bb4ba067bf6744540daaf8979deeca281b04b3d3905ebb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d093b90e6fdc98b76b3b9c8d0ec0aa39f820e2a2d307cf7cd83296b1b2eca177"
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