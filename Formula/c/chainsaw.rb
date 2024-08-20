class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https:github.comWithSecureLabschainsaw"
  url "https:github.comWithSecureLabschainsawarchiverefstagsv2.9.3.tar.gz"
  sha256 "c679873cb5ff8b88c400ea7d7e14e642bed81fe4d10d0db9ee87de61a68b31c2"
  license "GPL-3.0-only"
  head "https:github.comWithSecureLabschainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db2ec7ca6ff2c91d9d7922268d8373797e397e5e61f850116ec131f575b6c88a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51b2df3955ff3df19ed6f1e4e3d55448caf722507a3fba8816390c0e88f7f926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5865a8f49ec34be604dc148a42d35d83ff6f5388e415bf7855f13be3ed6b2647"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fe3f1c8765f2e9a443c3f2841a97602a20617449187771aaed112a8ab127ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "53d49f3e6b84677743de55a7ba1d8dcd587d9097a5ecf927ee42e20af8ebfd45"
    sha256 cellar: :any_skip_relocation, monterey:       "464a1d75c5e1378ada67fa3d654c916ffc7252ab9f43d0a65e8abc496adeca02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a5f675e9a2aff86ed645769f28ce4d91ad91155e718ef5192b707e9934fced"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}chainsaw --version")
  end
end