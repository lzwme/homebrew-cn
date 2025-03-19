class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.14.2.tar.gz"
  sha256 "85ea206d960d857bf728f88fb4cee7aa5b3428a69e62bc128484e5eb3f02a9d7"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4330e1137250d37ebd6c8ee2fedc03c110d586bdddacbb63d06e241b26958d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4330e1137250d37ebd6c8ee2fedc03c110d586bdddacbb63d06e241b26958d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4330e1137250d37ebd6c8ee2fedc03c110d586bdddacbb63d06e241b26958d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffc90ea0ffa5510523d0cc71e3424dfee56a7130a2fcbc2f58ff8c827ca2801f"
    sha256 cellar: :any_skip_relocation, ventura:       "ffc90ea0ffa5510523d0cc71e3424dfee56a7130a2fcbc2f58ff8c827ca2801f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead2f0f60ce9bd5544f814b96970e2d7d2da9f8ddac602ad801f32bf0cd94d7a"
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