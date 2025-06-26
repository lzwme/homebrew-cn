class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.9.tar.gz"
  sha256 "59ad9222da7aaefe091805df6bb78723cf91bf077a077df545e9125a9d719397"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9685e3a271b61c958e8c3d282fb6981c366be3d0d1438e1261facc4bc33b557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9685e3a271b61c958e8c3d282fb6981c366be3d0d1438e1261facc4bc33b557"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9685e3a271b61c958e8c3d282fb6981c366be3d0d1438e1261facc4bc33b557"
    sha256 cellar: :any_skip_relocation, sonoma:        "28f74968d40b36c7ecfc60dc81e998136a6d86970d1f4bdbf0e9acb444117831"
    sha256 cellar: :any_skip_relocation, ventura:       "28f74968d40b36c7ecfc60dc81e998136a6d86970d1f4bdbf0e9acb444117831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce3b345da7a3d2869162f7ae999fbe38efa879dd67ed1328e2f9da3fbf917a1"
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