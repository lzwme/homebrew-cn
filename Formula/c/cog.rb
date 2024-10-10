class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.26.tar.gz"
  sha256 "46ae16f928c8591622c8c61c44bce029a9a5202b5d65609ce505686d935f4e08"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3343952291b3eee0656ba53c3f4a9342432071fc1701f03054a5e5d4afe1f20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3343952291b3eee0656ba53c3f4a9342432071fc1701f03054a5e5d4afe1f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3343952291b3eee0656ba53c3f4a9342432071fc1701f03054a5e5d4afe1f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "056ca086a31900b35b9e0517483cad9da89665d5f3250a8f628191bbaf96dc39"
    sha256 cellar: :any_skip_relocation, ventura:       "056ca086a31900b35b9e0517483cad9da89665d5f3250a8f628191bbaf96dc39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727ce1d0bcb33af40b10b67a6750b3994fc24ab29fa4cc75f5873d6bd2e01efe"
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