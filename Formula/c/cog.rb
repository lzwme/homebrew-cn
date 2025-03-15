class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.1.tar.gz"
  sha256 "f2c8f7e549da1a9c3891ae679bad2a875593781b260f7e65c83bbfb913623e1a"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225e2fc0d351ccd075487a1af70fb0bbf68c0356c2570be54493c936ec931617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225e2fc0d351ccd075487a1af70fb0bbf68c0356c2570be54493c936ec931617"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "225e2fc0d351ccd075487a1af70fb0bbf68c0356c2570be54493c936ec931617"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7705b3d76e529647b2dc27e541a967384b931f62ab8ebb0bcf6f1e233a7bd0a"
    sha256 cellar: :any_skip_relocation, ventura:       "c7705b3d76e529647b2dc27e541a967384b931f62ab8ebb0bcf6f1e233a7bd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474559422fb19a5eb864aa277210d4c9f43bc88c038b7295cc5690548d7f5804"
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