class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "e4a2227cb0aa7b189549da36474d579230c791e66a02213636269284704b757b"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "315c032f97b278dad711b65d2be894e56f2ab5c5ed56117f4fa216aa08bcc391"
    sha256 cellar: :any,                 arm64_sequoia: "8470b7cb7e208be0b6d3dfbfc86b7da3190fa718d239ba9342249af48deec00f"
    sha256 cellar: :any,                 arm64_sonoma:  "ea2227534bc4cebc5f4810170519d9c86e56a91ca68fe5611d673d07fa9d671c"
    sha256 cellar: :any,                 sonoma:        "c1fb463503e1868ce24e30d2dcc060492ea54a82ffa878f839f5f95ca2e951bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885e22f6540458ec5702a0448d8d34ca3a5bd3767488f1998e5fca91743c1d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b62bba2fd19300be0cb65015e49b303cf8e468a4625054006be2489815c0b18"
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