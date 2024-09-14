class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.23.tar.gz"
  sha256 "584b12755755dd6f5f6f3a2ade84caaf97ef7cccc2e53f5ea1567faed030955a"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd9a6590710e03b8b818b2737530fc8e0bd28db88413313b7a24c12f920ad77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd9a6590710e03b8b818b2737530fc8e0bd28db88413313b7a24c12f920ad77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcd9a6590710e03b8b818b2737530fc8e0bd28db88413313b7a24c12f920ad77"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bde8e2dc4217768d01aa4badd24f18f33bc3a1f04630f1e699644f97a52ab22"
    sha256 cellar: :any_skip_relocation, ventura:       "2bde8e2dc4217768d01aa4badd24f18f33bc3a1f04630f1e699644f97a52ab22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29276031d930ab31beddefa0db380e1cdcc57686e5a071130fb090836841ddb3"
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