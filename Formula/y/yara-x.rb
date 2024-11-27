class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.11.0.tar.gz"
  sha256 "321a04a99c1b5c724a3f8ddce66a70e6fa2154300cf3828ba0d9faf615376cac"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8fedf9a8d9bd943610a66351a26e8a93b43d35735cc83aaa36f14b22ec185ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa53770cfc8da3f7806beb67ed4fd9d2ed3b9fa602841db8813d637529195ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8324ac1e70db6c9dbdd91d943124831d02ae4151ce539df624772393fe80d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb89db9150c7491509c285315ab596d0ede4036893a525f3dfeee6dddce91031"
    sha256 cellar: :any_skip_relocation, ventura:       "46ac0a2beea48ae9f8938982bf1f1029652224f75ded7525abe4adf54ebb2b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d4bdb7ded44671a3f3dc05083ba9418cf906b7e0da9d8d857c82394eba59de"
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