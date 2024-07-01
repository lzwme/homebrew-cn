class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.5.0.tar.gz"
  sha256 "cea25fe87bf1b5391f022921ed73e6c189e1ce4243be55cc19d61d63c6ebab8b"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d20e10d34fe6226a1d4bd688a9cbb3608f2f9e5a4fae238376947bd44ee4520e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2b59082d3c4d701517daf9ded02ae51b2e96ea951b2996b088ec136793e989a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c31057095bc979f3878f1d916a73237070c7aca9f118a1bd1a797ef60f8a390"
    sha256 cellar: :any_skip_relocation, sonoma:         "2637ff2ec3481fe54931dacedb49137c4d2403818d3e09791fbd8b3f886e5ef7"
    sha256 cellar: :any_skip_relocation, ventura:        "61ccfc8313c348c55ba5baec5f042b9ea8a1a277535aef867e81f232323e964f"
    sha256 cellar: :any_skip_relocation, monterey:       "ee32539f562c871e42f2cc1d8608f4b2fdaccab6dacca559ed714a44d1be8951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90037672029e987ed7bba4a38b2d3c89cbb7d172120c0deb1ca6bded4c4106c3"
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