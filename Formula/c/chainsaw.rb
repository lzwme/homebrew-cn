class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https:github.comWithSecureLabschainsaw"
  url "https:github.comWithSecureLabschainsawarchiverefstagsv2.10.4.tar.gz"
  sha256 "77c35c17b705dd26d5e353cc4a275484cc9ef7789c5aa3e9b813f985021361b8"
  license "GPL-3.0-only"
  head "https:github.comWithSecureLabschainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32da83155c7fa9a338e7b896965b36af2fe3a704e89856f412f83618c2a4846c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "332d31642f9e02b6c1fbc192f411f44c5e40551fecb69a3f393e01459de0950c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaad6e02e054b1ef4fe828bf2707e760fddd01cb6fe968743da5aa75866552e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b30ae100165de2ad4922eb81626e851af5b7e18c853daca9a64c0457cc3468e"
    sha256 cellar: :any_skip_relocation, ventura:       "91fb90650e6206d434a1580fb744350d99e4560c598f4920578761b717970bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcfc87999e1792071b56e13e002395d4e5c9276151e24fde653820e8b3833262"
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