class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv0.12.0.tar.gz"
  sha256 "f73f7c3d2b38e7190d9b588bbc4eb6664123cd95a10c30e198f0653da1db8932"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9a5a4729ce56e0950aef1df94f3ad469bc18184c748899615d2829e9b35f627f"
    sha256 cellar: :any,                 arm64_sonoma:  "f48cc85e4dad3afeaf032454de8990dbb9c42360b496a3a03c48afb5a37f1721"
    sha256 cellar: :any,                 arm64_ventura: "a1b30a033f96edaebe26b64306c14a44d4af44965bb3ffe27d2679d0fd5bef83"
    sha256 cellar: :any,                 sonoma:        "29d52aa07c219ace39bb37501755496463e8b7907382d18ed9e9cfc95905fa0c"
    sha256 cellar: :any,                 ventura:       "2cd0fdac5eb77c6329b6ab061e777d2c80dc9fb18517b01a4aced63dfd8bb45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed661fa8e266886a960a066e790238b68ae0adbdff42cdc331dbc94395febdc1"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "cargo", "cinstall", "-p", "yara-x-capi", "--jobs", ENV.make_jobs.to_s, "--release",
                    "--prefix", prefix, "--libdir", lib

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