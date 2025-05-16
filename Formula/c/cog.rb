class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.11.tar.gz"
  sha256 "826479d806d15dcba6784ffe4217216d749e523ce7105ecd39ad17de94acc476"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b736066a8d2cdcc40f5ed3085f52b4a39dbac1b39f79989ae2084ac0b397fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b736066a8d2cdcc40f5ed3085f52b4a39dbac1b39f79989ae2084ac0b397fe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b736066a8d2cdcc40f5ed3085f52b4a39dbac1b39f79989ae2084ac0b397fe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "311b4fe0fe996095909066fbb09f006bf541dc830695096f5b6d70af739739af"
    sha256 cellar: :any_skip_relocation, ventura:       "311b4fe0fe996095909066fbb09f006bf541dc830695096f5b6d70af739739af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39602e9b24a3dca58749cbb880cb697a0b58b3fc9e4c4392b9e3db5a6188062"
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