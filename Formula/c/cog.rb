class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.5.tar.gz"
  sha256 "91e11b5f6d87519d326beac6c38da7f34565683f0d62e7c30c194fc5f412b234"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f2e08a845764f3677650e36cb05ab88cdafde5a057d60a8faf64146f1ffe6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f2e08a845764f3677650e36cb05ab88cdafde5a057d60a8faf64146f1ffe6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01f2e08a845764f3677650e36cb05ab88cdafde5a057d60a8faf64146f1ffe6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "096e053c52613d6e71185eb50c124e7798ec1e659b84ad4849de3a8d1e027e1e"
    sha256 cellar: :any_skip_relocation, ventura:       "096e053c52613d6e71185eb50c124e7798ec1e659b84ad4849de3a8d1e027e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55db411f9efacf7aac1b40b765bdd38ce0169905d5c4ee957516cddb22b98688"
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