class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.24.tar.gz"
  sha256 "af0b16b1802b6813584a3829d20b95535c75d67abca72b22f84a64f7fb5841b1"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76c09ca369afb2d9992ce2da33b24e1cc6742807319017691a4bbe86d92e1671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c09ca369afb2d9992ce2da33b24e1cc6742807319017691a4bbe86d92e1671"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76c09ca369afb2d9992ce2da33b24e1cc6742807319017691a4bbe86d92e1671"
    sha256 cellar: :any_skip_relocation, sonoma:        "55979592956b8e4f976a29c3246af6021dcd67b8d36d15a5095dab78fcebab5f"
    sha256 cellar: :any_skip_relocation, ventura:       "55979592956b8e4f976a29c3246af6021dcd67b8d36d15a5095dab78fcebab5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bef88a58ddff2564841882ec4617ba40c3c0726950c68e98d323ffe6e4d71ad"
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