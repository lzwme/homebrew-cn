class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "d0bc7d3ff356416e6c236137b1893983b876e92fbc40faeb8e630e840acb15c8"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12858be40a6788c02f5182290663456722ae650901cf053791ba74b072474e18"
    sha256 cellar: :any,                 arm64_sequoia: "1b2fde6bc56cb803813315607fe34bd52a9d0b991db1c4b0a2e495c997d2df6c"
    sha256 cellar: :any,                 arm64_sonoma:  "e390def5e40f2f10387103e60b982b71021535fe3748dfda1beff44f56cf5e7d"
    sha256 cellar: :any,                 sonoma:        "eafe5f0cfc8f0e5e3335ed82f8edce8ffaef9dff6e18eda3eab27ac2ffd7bc20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd2c36af36da5a83064569596da1b6755f8990488e653687614d763e30480ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596473fa887462bd2ab8b597ec231c2ca332b3f65f81f24efa3db33ec394fcf8"
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