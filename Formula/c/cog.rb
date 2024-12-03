class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.13.5.tar.gz"
  sha256 "0916c9f2aeb9448b5d405dc58cb427adac9792750ee4c0b4c47fb160361f07e9"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb3c00620a09b4e5bb2acb350aa63f90feffb774bbe03f0c8e3625f675a9bd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb3c00620a09b4e5bb2acb350aa63f90feffb774bbe03f0c8e3625f675a9bd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cb3c00620a09b4e5bb2acb350aa63f90feffb774bbe03f0c8e3625f675a9bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e7eaafc8de2675e36e47c46417400e5b55a4a6e1bf89977e8114b565721115c"
    sha256 cellar: :any_skip_relocation, ventura:       "9e7eaafc8de2675e36e47c46417400e5b55a4a6e1bf89977e8114b565721115c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24842dc5fa7cbe8185b0e303a9adc81a4d7065e655f5946fd367a9ff6d9c580"
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