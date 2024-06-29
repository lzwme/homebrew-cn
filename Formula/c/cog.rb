class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.12.tar.gz"
  sha256 "6ed976976b0fed8e3424966aa1b66703116cbc4adf677ba0b317b4de1942cd4e"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05e2fe7ffecc1dc79c75e29c630f67796c815d2512d5bf6e811c3cfcec7301a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ce7f37f656297f1e266a65bb343a7661b8857f00512cefe766a6c0977c0c353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4744371ef704a082baaf7dbdc01abd0abb144c63205dd222e8cc10774ea74681"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e449ae46005e38b07ed89c40f206c8ec5953b60764311be3e3a5a34ceb4af14"
    sha256 cellar: :any_skip_relocation, ventura:        "600d716bf3a5f4ef175946c992bb6586ebb474ec2bc8c541de5f689068e213e3"
    sha256 cellar: :any_skip_relocation, monterey:       "8de83b1302c1104d7e5085bb778bab125eaaf9139b03c45c8cf94b19909801bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4044f9f7bdd7338d2fd5ae0a7e62837d718ad18e1fe38b586208c0b69a415153"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

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