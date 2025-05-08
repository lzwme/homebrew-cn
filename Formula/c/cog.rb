class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.9.tar.gz"
  sha256 "3e5db97b0cd59b3e0106371ef37c1e2d8c542f74c6aef1dfd58c6cbd67fc0705"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c952ef491df77534a33e12385047694246eadbc9a54aecb9bae416024d9d2cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c952ef491df77534a33e12385047694246eadbc9a54aecb9bae416024d9d2cee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c952ef491df77534a33e12385047694246eadbc9a54aecb9bae416024d9d2cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "961445b3064c1e292c4bb39e4789deb864c78a1626a27bc12d53921f09565e68"
    sha256 cellar: :any_skip_relocation, ventura:       "961445b3064c1e292c4bb39e4789deb864c78a1626a27bc12d53921f09565e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db663aad500610e5b9e4f8fe11e5b7846b10ef16e2f2e80ddb36b0cd2aa714f1"
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