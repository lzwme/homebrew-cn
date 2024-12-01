class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https:github.comWithSecureLabschainsaw"
  url "https:github.comWithSecureLabschainsawarchiverefstagsv2.10.1.tar.gz"
  sha256 "f2c8d6a3e7d982b8dc5fe95ba17463c1cf2bae44e61a7382bcea5151b6fa174b"
  license "GPL-3.0-only"
  head "https:github.comWithSecureLabschainsaw.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b250abedc99351c6ca2b240b14c039dcdc90dcc8113cfd141a83e1de484885d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1264a2c8f3583c335a8997d94e155fcee58a830dabdc0953ef5cbf2e4a2d3fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d48cc00e941a86157a0a39a4c8005eb62af1077d6be148d47db5a76c65f665a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde31154a39a7d002493e45126c598df20baf3a7fbbc6041239d902f80be296a"
    sha256 cellar: :any_skip_relocation, ventura:       "4a43e20781c0bec2fa1aae67bad6c00704d3bad8116466f4ca4f2ca5afd23a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a207662a49807661792ef138a4f33fd5fbde24defe0a0088c35faf563f132702"
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