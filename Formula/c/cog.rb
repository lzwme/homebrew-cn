class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.10.tar.gz"
  sha256 "f82c646e653e1fa2cc361ca44a2d56b0c3f65e7b0fd941b5f1bcc1178db997f1"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f7648eeb2aa56a46785aa2eda8ae794f42631d1955887f6fe6a85bc48eec61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f7648eeb2aa56a46785aa2eda8ae794f42631d1955887f6fe6a85bc48eec61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1f7648eeb2aa56a46785aa2eda8ae794f42631d1955887f6fe6a85bc48eec61"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bd2ea92f15eebe076ecf025bfd9a73e9b432e1d41011d77004d85e78c6073c0"
    sha256 cellar: :any_skip_relocation, ventura:       "4bd2ea92f15eebe076ecf025bfd9a73e9b432e1d41011d77004d85e78c6073c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86cbbe50733e834a0d8a36fdb84f3516f4de882c9114d1624bdfda2d15f77b5a"
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