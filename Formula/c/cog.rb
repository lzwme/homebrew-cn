class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.20.tar.gz"
  sha256 "c4b6520953f1c975683e98a439724eee94efb6bdbeb716e6ac01406ed0babf75"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddbc693d90b3acede57abf77909e52addfebb102446c7dbcc78bae9b7090e3cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddbc693d90b3acede57abf77909e52addfebb102446c7dbcc78bae9b7090e3cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddbc693d90b3acede57abf77909e52addfebb102446c7dbcc78bae9b7090e3cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "61c4a09bd39cb0adfdea0da9fb43d8271f7dfbcd5cb28c560ef63e0401685ad2"
    sha256 cellar: :any_skip_relocation, ventura:        "61c4a09bd39cb0adfdea0da9fb43d8271f7dfbcd5cb28c560ef63e0401685ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "61c4a09bd39cb0adfdea0da9fb43d8271f7dfbcd5cb28c560ef63e0401685ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d8dda967c04cc0eff4810ee1fd0cab3fdbc2ae4736b9fd13f5dbf4bf155a05"
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