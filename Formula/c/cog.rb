class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.8.tar.gz"
  sha256 "df1c9679cc7dc148ada46776fbdea3b6b76def204eeb8943ba5384419ada14ec"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c6b048e385a28507b106799abf9bc2052fa149f524abdbc74ba4ad3392e7f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6b048e385a28507b106799abf9bc2052fa149f524abdbc74ba4ad3392e7f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c6b048e385a28507b106799abf9bc2052fa149f524abdbc74ba4ad3392e7f46"
    sha256 cellar: :any_skip_relocation, sonoma:        "456bf113b2e4795deb2e9655922fb83b9559db4d52226170059f57da743d6ae6"
    sha256 cellar: :any_skip_relocation, ventura:       "456bf113b2e4795deb2e9655922fb83b9559db4d52226170059f57da743d6ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3830c4bee5a82d54355708e0d590b877eb298da02b8704d4fff3112ffc122fa"
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