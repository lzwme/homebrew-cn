class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.15.4.tar.gz"
  sha256 "0eb6181e152f6c1bdb907b78d7425f2832251150eb541796203a989bf0eec17e"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75cd4cd132fa24c4aa66d8339868160eb83ad47782cb4c9b28be439ca64ce54c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75cd4cd132fa24c4aa66d8339868160eb83ad47782cb4c9b28be439ca64ce54c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75cd4cd132fa24c4aa66d8339868160eb83ad47782cb4c9b28be439ca64ce54c"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ed4d20307a342df42f330b50cea7fd3f9fc3b82ed6acc793434fcb8af2af67"
    sha256 cellar: :any_skip_relocation, ventura:       "88ed4d20307a342df42f330b50cea7fd3f9fc3b82ed6acc793434fcb8af2af67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86ee55185beba9fa93c7a13c26775596548e277a5532f055dc7d6edeb950590"
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