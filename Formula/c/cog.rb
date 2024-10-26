class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.11.6.tar.gz"
  sha256 "515ebfe39082a095883a3c05e6e44141448ee536337c0f9c0ef4bd5708f0be08"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2115659bc2af61e69fe3f5bc305617453b8fc86e6910610c0bc56f2d566f11f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2115659bc2af61e69fe3f5bc305617453b8fc86e6910610c0bc56f2d566f11f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2115659bc2af61e69fe3f5bc305617453b8fc86e6910610c0bc56f2d566f11f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e62d0d8d7b82144589d4468e8f6690fb363ebf0a042f11176e6d7c6fc87da6c"
    sha256 cellar: :any_skip_relocation, ventura:       "7e62d0d8d7b82144589d4468e8f6690fb363ebf0a042f11176e6d7c6fc87da6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44f4dc72847f75c4d5fb1c2189235536f6e2b207e7c43b5f92a31009de42b62"
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