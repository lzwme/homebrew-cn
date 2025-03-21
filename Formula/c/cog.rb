class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.3.tar.gz"
  sha256 "0ffd36e5ed14b5bac73878ba2a74d52c0fea669209ead45d24ff97dd78d37aba"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c3377c255aeacf138858ffbc46b76c7b1d8e7bdd3bbb154a2f08721ed4658e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7c3377c255aeacf138858ffbc46b76c7b1d8e7bdd3bbb154a2f08721ed4658e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7c3377c255aeacf138858ffbc46b76c7b1d8e7bdd3bbb154a2f08721ed4658e"
    sha256 cellar: :any_skip_relocation, sonoma:        "361fa4dcadfb324cb90bc08ca3455f46f2e1ea8886bf93ebf0e8095f7d772add"
    sha256 cellar: :any_skip_relocation, ventura:       "361fa4dcadfb324cb90bc08ca3455f46f2e1ea8886bf93ebf0e8095f7d772add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4c599886aa97a4af46837db898d09e3873f11e16c2fbbdbd77e4a34cbb0cb93"
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