class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.0.tar.gz"
  sha256 "cd5baebcc49e9f180cee0b7c023e149a345fda7c607dabe247ec7cb975965866"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bfc4223186506e2964c6d96059b5146887f8a917cf273f7fc8402734588ebef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bfc4223186506e2964c6d96059b5146887f8a917cf273f7fc8402734588ebef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bfc4223186506e2964c6d96059b5146887f8a917cf273f7fc8402734588ebef"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e58798e17d16f9dd4fe9654349abbcec00f56f89d5ae84bb5ef0bc51b23953f"
    sha256 cellar: :any_skip_relocation, ventura:       "0e58798e17d16f9dd4fe9654349abbcec00f56f89d5ae84bb5ef0bc51b23953f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d42c35a5b6b91f0c34624fbccb65c7bcc2be2c5c59cd3373c883dd89f6f25a"
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