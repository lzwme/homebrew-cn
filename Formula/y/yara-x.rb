class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "c9b42e84e2452f2cd501d18b0f7ea35a598edb9e23c6dc7b1165ccab9f04c84b"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d1a510dd10f69d3bf0a1d3d2b460cee8f1b7a38ed4d0e66eb60ce881300f4f9"
    sha256 cellar: :any, arm64_sequoia: "925f277b809f2b449b10755647a3d6e3be0af33b90e2f00fc18f548b10064599"
    sha256 cellar: :any, arm64_sonoma:  "1a2f34a660a85f0b70c6336cb72685c7079f3f84613cdb42d7e4d5286fff8a82"
    sha256 cellar: :any, sonoma:        "02242e0254b381ff65df83d56df9185ba4e2b6d75dda0aec77a312195d50bc24"
    sha256 cellar: :any, arm64_linux:   "4540e61844a155d95ffa4f0cd902c3e89a14aa3d2fd8524a17e8280cf06b5075"
    sha256 cellar: :any, x86_64_linux:  "d953db6b61615e9b74475ce9d5b3da571dee1671a4f5c4862433b1495064eade"
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