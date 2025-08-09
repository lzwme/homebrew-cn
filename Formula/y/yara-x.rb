class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0900ad4b230988fdf4e587fccc22514dd7ff4d3985430712a16ea3144e3911dd"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c883251cdb3502f9663788677dcd08fb3e610115daa0dd44c5bb66f93a275fa1"
    sha256 cellar: :any,                 arm64_sonoma:  "12b3bfc1eb4b46e08a6e5d3da7d32836a1aa4996dd4d02ca90f12d31750d721d"
    sha256 cellar: :any,                 arm64_ventura: "d335298080c24daad304a77fb3efa79a998896dbb5d39d2577aa5bc80d4d5efe"
    sha256 cellar: :any,                 sonoma:        "ee5d9189fd9b2eeabbcdc2ca4b6a567b38d73dc669b1c7a0b16c10cb0a560ecd"
    sha256 cellar: :any,                 ventura:       "fd674c3c66843b649aef4a535495d900c840d40492ccd9e15a0517d42b6b1bf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c53afff4bc3f1588a6145ba165bdd0eaf66985470b5d95b9b938c6eec115f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98c787f85555419e5c4b4943ac1ef9031db9230a805aed4d9976cde90ee02dd2"
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