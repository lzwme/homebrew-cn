class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "f6230d61ae85356e3c9e9f0fa7c7c94c01d783ec8c43537158e89ffa28e21107"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b40496b051a56dfc547a7c81fe9319a45ab1a51c1de87d2994fa18ac6771901c"
    sha256 cellar: :any,                 arm64_sequoia: "a05ab1794a6f44310ae39fe8f659e07072b9d214fbe9b49c9d9ef740ff8bd995"
    sha256 cellar: :any,                 arm64_sonoma:  "76f13c7799106348ca4457ece84605f1f39176f7612e24e36deaf928c5b7f9f5"
    sha256 cellar: :any,                 sonoma:        "caa048b9b6d6f9181900412b290cef672134a7dd66ebbd831862fdc602e15f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3fc9db41b18d3c709b96477799fb4da01f9928dbdf70d7eeeef8b130b820598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edfe433d3cfca706e83cbc168fec4865b54b973fe795c55e2fcca296a76fe173"
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