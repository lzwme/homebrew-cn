class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "4569f12297189a94678ea0ef027384d4cf0065b5b0892881cbae097b6f29a2e8"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "993deabad98abdbcadfb932d1d207a6fb58bb6f3d5ffb0bf2e7afbb2c08d110b"
    sha256 cellar: :any, arm64_tahoe:       "84720a28eee521e145ae70bdf4fc711d57e5659cba54c8f1c36ee2ee8aabc288"
    sha256 cellar: :any, arm64_sequoia:     "515bf6522fc3c71b023d6f32e638e462c53d835ab8c30a118479a142f98b7f39"
    sha256 cellar: :any, arm64_linux:       "b3cbf3034935ff2563e4e2c28e8aae8fea76e9a24dcf79343557dc1792bc63f3"
    sha256 cellar: :any, x86_64_linux:      "94903bdf44b00906a3d50428bf7c29050bd24b0eac781fbfead9cc61cd8342a2"
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