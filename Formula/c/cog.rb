class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:cog.run"
  url "https:github.comreplicatecogarchiverefstagsv0.9.8.tar.gz"
  sha256 "19a0197360fb7b84db049e0fc5ec4ecc3d61d5ad994d0a15a974f3d194906391"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d9dbd890cce899abdc860219d1b932788df0435d931935cddb7ae156a02a8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "233a3c8fb38132eb125d154118b67f880fc5bb89d7debcc9bbfa5e741408ce14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca83f2b806d96f96d95254324d4bbc12e9d41b2a87c5a6f71c1793bbba8d3ca8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1c8dcf80894864912a76fa2d1c6d9ad12c166cb33ca0822ae4375959cf93ae7"
    sha256 cellar: :any_skip_relocation, ventura:        "eb9c592487d5dfaa5ebb32ab6ef372c2ce36bde4c77dad8df39df9812b07e69f"
    sha256 cellar: :any_skip_relocation, monterey:       "1441637b866cfadc51bed3eac8e6706643cfad368138980fa9bb5d7a13b4f313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d169a8d1d92d9e1102c9f99e6940e9032738c2f79b0af597ff7163f782ba3bfe"
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