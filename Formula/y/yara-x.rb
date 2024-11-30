class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.11.1.tar.gz"
  sha256 "b59d9d91f05bfdc0d9fa74cd30ddff0885afcd4f0f28afb0d27d9474dd65969d"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236c5345b7f5325f83a360259c6b340f60ce630ac80f898dc3454b16545bddcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de6712b7201f22e0c60f6364d0da82083d26d858af5364af6681903e9a1e1a47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b854718279a77d728fbb5e7f31e7d9dfb2edab47b3ef655c30e26e77e6bb98af"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c72b45efe64c6bec8cd5ad28d8a8444ae0d8c0dbacebbf499d775c085db45e4"
    sha256 cellar: :any_skip_relocation, ventura:       "f395ce5f97a0d4286b2bc17f79fcbd638ea91a83cf2c65fc05ca72ce282686aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc99979b50e30c42fdb5943bef6c8349da9a5e0459596b6051c0cb280447807a"
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