class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv1.2.1.tar.gz"
  sha256 "e0457c0cd4f6a7a1c4c0e5df7453af49f3d8027453fd1fc053a1491ca1823122"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "272efeec017cc0a10e1a97531ab3fc04cdf9e829dc203f0166b803399502f476"
    sha256 cellar: :any,                 arm64_sonoma:  "7efd2803640931f8f804af21c009c6df0dbfacb06ccf71442b328e520a36ea0a"
    sha256 cellar: :any,                 arm64_ventura: "5cef330438cdf6d29a3287147d417cc06a02bb3b64dd999587089ada3b4fb3e3"
    sha256 cellar: :any,                 sonoma:        "a5db58245877394b54e8011244c62b9d4ea395baedf87f3bf5b51c2dbf173064"
    sha256 cellar: :any,                 ventura:       "ec5960a7853206a654a3e5e81e895b6834568b3ad88580d52e8c2349ac5d37a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a374a246b80b4ea6dec71c1bd783d32242367aa892862c760a0932a8a62d1ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b3412a96d5827e46654e742af4096787bbecaa78e6305dd50acfbf582da63f"
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