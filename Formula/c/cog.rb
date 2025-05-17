class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.12.tar.gz"
  sha256 "8105b32b8e8f0c23651c1f28be96f1b5ed91be76f8b7abf1c40b89a1907ceb85"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ee32bbb76c206e034b571aede364e818cf416044ac586545a7f5dd8e9e19e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ee32bbb76c206e034b571aede364e818cf416044ac586545a7f5dd8e9e19e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50ee32bbb76c206e034b571aede364e818cf416044ac586545a7f5dd8e9e19e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "23334389cc55c1ebb0fe3ed4bcbd11f698da98a657162ed6e46de59fdaf02dce"
    sha256 cellar: :any_skip_relocation, ventura:       "23334389cc55c1ebb0fe3ed4bcbd11f698da98a657162ed6e46de59fdaf02dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e526d5c6ee524b81807466bf8fe63c02617575f09aa911a3d817a88c9ad5052"
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