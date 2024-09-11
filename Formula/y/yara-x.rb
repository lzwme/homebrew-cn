class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.8.0.tar.gz"
  sha256 "dcb8148f0bb0338c2a9c0cf0214e9107078a731d37c4827f818c1f707e1e1b64"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f65941c1ea6981605cefe7f613e360544c4b587f77d35751c0bfca583e94213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d07c273792b3247b645228e4936fa41b7160705a51c6345b5c8e40175017ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6254846e09e3abf304309a769434187d38e7547b5ad333884dff83c250df8b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4cf8848c817ed28325828fdf979d38acf27a5e87e7094bf9154b374b6adee32"
    sha256 cellar: :any_skip_relocation, ventura:        "921270a09ed7bc32ec8707a5adc3bf1531b46b099dab89d95d48bb53fd3e121b"
    sha256 cellar: :any_skip_relocation, monterey:       "dd5c0e89b9e48148c3a0a5cd21b6312112c20ba1471d0b3a2e46529938a6b6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20fcbd59e6bc42f84725bafdc3262c8ea4525ead010defb8782dc3e638cb51f3"
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