class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.11.5.tar.gz"
  sha256 "5c94c19fb8387f545fa28bfdd5b215a4ab5e7f4897814106bbfb2dcd315e1ae3"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02ddb41d31e25fd825c686869831d4aa190b0e06ec512342001e867e70861b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02ddb41d31e25fd825c686869831d4aa190b0e06ec512342001e867e70861b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b02ddb41d31e25fd825c686869831d4aa190b0e06ec512342001e867e70861b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b56c12b72a8d3efc4ea3591d0fe5c4578e3c79f349242f5912dbd845b9348c6"
    sha256 cellar: :any_skip_relocation, ventura:       "7b56c12b72a8d3efc4ea3591d0fe5c4578e3c79f349242f5912dbd845b9348c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5934ad4b21bb4e194349e47f218393c994fd345c143b7ddbdec5758a289a73a9"
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