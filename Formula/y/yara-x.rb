class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "79c0f5496d5115863e22cfdc04837cb12650fd9f0d826a86d5e9b7f4b20ccdc7"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98a1c108e717b3c1f874d175f0d216098391afb060006f3562d4490b41219fad"
    sha256 cellar: :any,                 arm64_sequoia: "b002a32caacc4bbe8cc4bfad3856e4818a774015d89d080b3ef720e77b827fb5"
    sha256 cellar: :any,                 arm64_sonoma:  "d527cda89ad80bc352ee01a4fee47cf070b5157ce40ba4657cf07b4a7ad93900"
    sha256 cellar: :any,                 sonoma:        "1b5ed2c912f2ea08e986db58cfa2211c713b6cee23c68c2d1c67759f3279cc1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed9c4f4f893c895691ad179f8e4b418a0a43f302348d2e142942b7bf7ba008f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ae9b314427980797bf37d235ea8575e31253e39dd35eb7c451fc144a7362c0"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "cargo", "cinstall", "-p", "yara-x-capi", "--jobs", ENV.make_jobs.to_s, "--release",
                    "--prefix", prefix, "--libdir", lib

    generate_completions_from_executable(bin/"yr", "completion")
  end

  test do
    # test flow similar to yara
    rules = testpath/"commodore.yara"
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

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal <<~EOS.strip, shell_output("#{bin}/yr scan #{rules} #{program}").strip
      chrout #{program}
    EOS

    assert_match version.to_s, shell_output("#{bin}/yr --version")
  end
end