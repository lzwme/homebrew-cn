class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.3.tar.gz"
  sha256 "74151cc6222a879ff0407ce9fb1c3f4aef18a1a1fad1025b8d6ca770c9bda9ab"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c1af340c7668036e7045f80a420947712b236b9eb2178c9f2e1c8a718d8f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c1af340c7668036e7045f80a420947712b236b9eb2178c9f2e1c8a718d8f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5c1af340c7668036e7045f80a420947712b236b9eb2178c9f2e1c8a718d8f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f5057c57fb09179f5f8c9a031a2e9a86e4f9aca2c5bfdbf4ef95aed058fdc09"
    sha256 cellar: :any_skip_relocation, ventura:       "7f5057c57fb09179f5f8c9a031a2e9a86e4f9aca2c5bfdbf4ef95aed058fdc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe35251dc1502ae1cd58ad7bf3cd8294224c98d71a29e6b130a1ac10ba3bbe8c"
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