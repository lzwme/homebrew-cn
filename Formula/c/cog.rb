class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.13.tar.gz"
  sha256 "762729db54dea7fc5a23b8302c6c1b4cc857908305ba35ac8dd71f508e3941a8"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ed756fc89f4db696470fb64e312fe58764fce1aac5dc6b7bfec4b62fdd5565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1656b889868d7a91b96e30d038d4fe047d4b22c769ffdc4f36561cf3d50831b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe06f2e0321660f7ee28d3a7af85aebd14c5db9779d8770eb7ed1ec597695ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bcb07349b891a53e579243d8325b032eea3dadb36fbc8543db45c71446b10af"
    sha256 cellar: :any_skip_relocation, ventura:        "0880ede9bd576bcd554b0812366359605668539f29b4e47dd158fc2a96f2baae"
    sha256 cellar: :any_skip_relocation, monterey:       "a929267b9cd0d1fd7205bb2a67368db026e1cc3cd80319b3b1d833219e792146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf514359845b6e557867bbf18ff616a36d2a235fc6d29a23e09aaa672ea0ca1a"
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

    system "make", "install", "COG_VERSION=#{version}", "PYTHON=#{python3}", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}cog build 2>&1", 1)
  end
end