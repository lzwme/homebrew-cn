class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.7.0.tar.gz"
  sha256 "cfd9e3ae796e0b5001e7f80a3cfad5d510c54c393299e5701ca9232e31267520"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef29bfdfbf2b33bf1950dba8388444d3bcfdfc9e04e1dd715b2aa51a14e60f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b1be7cdb19d0e9e7a2b009eea022810c3b811e029e27ce28746300335ec1629"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f313979bd2df47487aea9802e73ea56333e04fc8bb3b34ee745591c38c3e575b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c44c1232b532e3d4756b08c5809ec6591cbcd7b0ef097809338f4434e6bc93f"
    sha256 cellar: :any_skip_relocation, ventura:        "04a794b32b26bc1b33405a5d9ae180de61ccc4fdace31fb2e1b8dd09d98603cd"
    sha256 cellar: :any_skip_relocation, monterey:       "585f626c566d54c762d9a92a57e5f2b08de08b760a5a96a0435152f03203fa6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8721e35a377e4875b0e3026c18209156a5f44408902625aa506bedb35539b0ba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"yr", "completion")
  end

  test do
    # test flow similar to yara
    rules = testpath"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}yr scan #{rules} #{program}").strip

    assert_match version.to_s, shell_output("#{bin}yr --version")
  end
end