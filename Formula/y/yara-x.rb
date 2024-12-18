class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.12.0.tar.gz"
  sha256 "f73f7c3d2b38e7190d9b588bbc4eb6664123cd95a10c30e198f0653da1db8932"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c11ca224f89e699dcfa63955e012992e7e00d3168fbfeda85778bb8b7308c456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2654f91b33d943709fdb53f404734d1f860ab5a057895ad0ef702ad9f451f538"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea3de5b2f6c193a7b76d48a6217556be731e4f177967738c4285c7d1bf9fc60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5193d8f4e3d614c7a3f973822b61590ef8a159d941f6cd7a73831a184ea88cc6"
    sha256 cellar: :any_skip_relocation, ventura:       "ea70418bd8a8109b21f74ce340939a5a0aff36a0750b8812c0d18632e5e4742a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8ec8bd9807a760e9d048969158301e2680168f1479865723ea1eb94db49215"
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

    assert_equal <<~EOS.strip, shell_output("#{bin}yr scan #{rules} #{program}").strip
      chrout #{program}
    EOS

    assert_match version.to_s, shell_output("#{bin}yr --version")
  end
end