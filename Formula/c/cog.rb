class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.13.0.tar.gz"
  sha256 "9cf64ad36e777db46a54c40f4e0caab43db7c47982708afa53d5de52d7c55e39"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e522f9192ede61ca93e4b21d04ff113ee3cb6dfaa5ef5d7a1d48303abd3d3990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e522f9192ede61ca93e4b21d04ff113ee3cb6dfaa5ef5d7a1d48303abd3d3990"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e522f9192ede61ca93e4b21d04ff113ee3cb6dfaa5ef5d7a1d48303abd3d3990"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6b4a94416e46f98e3815a2f22ac627c3aee7fbb7bdc0d28416a8d0e841ba2e9"
    sha256 cellar: :any_skip_relocation, ventura:       "b6b4a94416e46f98e3815a2f22ac627c3aee7fbb7bdc0d28416a8d0e841ba2e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5c6f9b807ae31b4e6845a10592013eccb725baf5b1ff89124bf27fbb3bb847"
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