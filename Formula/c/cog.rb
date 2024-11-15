class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.13.2.tar.gz"
  sha256 "6ba5c18fe60c93027096f94633780259924088a22013bf60ef7b4dbfa47f9075"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e30c014c24592fd4fd73d582e8621bb8e4b1355e315cadca0f167a431dcfd3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30c014c24592fd4fd73d582e8621bb8e4b1355e315cadca0f167a431dcfd3d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e30c014c24592fd4fd73d582e8621bb8e4b1355e315cadca0f167a431dcfd3d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bacedcd6ca005e34227fb3c793e162b8aa864779fb041be6af178767ed0ce804"
    sha256 cellar: :any_skip_relocation, ventura:       "bacedcd6ca005e34227fb3c793e162b8aa864779fb041be6af178767ed0ce804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb08997b84894fe8fdfb7a6f7f25a80609f15c7c894d702d8375ae2f2bb40588"
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