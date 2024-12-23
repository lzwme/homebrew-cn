class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https:github.comWithSecureLabschainsaw"
  url "https:github.comWithSecureLabschainsawarchiverefstagsv2.10.3.tar.gz"
  sha256 "cf8e11c80c995cfe37f761bfd529a323dac98c27a011f56fbd56222d4d9478be"
  license "GPL-3.0-only"
  head "https:github.comWithSecureLabschainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0582f29feaf8ea05001bed106f638f828b9481d2583d276abf25b6af3bd94819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163711f26002ae1e6625221267d75ff4686e06f99b740a27df14cdc31622d5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b03dba1fc9f6298753e2ec2b4f4730cf9bfa28db734a6a351851696911d7903c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2cca9567c91fdeeeaa8acae12a2da6972a1b24030f6948bd58397e5e6dfa5cc"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ebc314c5c5c5dabe3381fe958a93b6885fa5ec184b73945cda4a7184bfa83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75f101e6a7069fd691d364818704f35e923f2dec83222b9de4be62121d9ee71"
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