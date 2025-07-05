class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4956bf63a1bb87557d5b82ef3253dacfcf941d9b351c395dc85635acec81b652"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd19b7ed033b8b5daf0d887c2bff4d0f343815df5e6b75b19c5d1605b9775b92"
    sha256 cellar: :any,                 arm64_sonoma:  "527fdd70029f661dbde500a42a7b7dfb034357ec444601335645c00682b75a7f"
    sha256 cellar: :any,                 arm64_ventura: "860cdfa057bb43b33e25b32058c26754b102e555afa1a5d9c383176b77fea3de"
    sha256 cellar: :any,                 sonoma:        "18ec6f77f58f29a40f3b12e6a23baec1981d6cc68147a569240e372ce2e2df94"
    sha256 cellar: :any,                 ventura:       "7fd38c0f7b989c393f9b55f0d601a7bc82c7a8ae33a4d4355ac907fbb62e16d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f116c2323f19fe4cc62352bd0f20c033efcc419229b7c5cffdb8f0c749e4b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8dd5b702c288beee8dd83840ddc7f0662912db0cb4d58ddc6c7b3141fb58f1"
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