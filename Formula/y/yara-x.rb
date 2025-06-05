class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv1.0.0.tar.gz"
  sha256 "b6d06bbee0c11c403f535f8352f4d86ee2d505a51634a88414fa6dba1aae14f5"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "102e2f9c014783df25d39777bdacc774aee245e06c3c1e2f49f104c103352cc8"
    sha256 cellar: :any,                 arm64_sonoma:  "a9dee2b67efc3a063daf08714555b69057c3f376db67f373f321fc56616400e4"
    sha256 cellar: :any,                 arm64_ventura: "420c8ab6f5ba6103ff591f6b14cc875b2de3bceb9228cb600fc978a0cd78e7d6"
    sha256 cellar: :any,                 sonoma:        "e20b565e80487651c6d69a135fd9560182233f8f362e8a6cba85dd65bb25411e"
    sha256 cellar: :any,                 ventura:       "87ffc7ae718b8512f90ac554edeb80b9e43dee68046f14abc95bbb737991cf6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ea88acb3f243dac6665c201233b77aa49edce0a4cf67bd20ed14aa92fd14499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22593b427d22487219de4251aee629bd390ef7a58df169c71670a60731119337"
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