class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://ghfast.top/https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "434375b4b776e112ad15657110d8b0dbe787ebae92a9f20a69f9e01f57002476"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e47c85e98f0133d4a29cb89be893e32d4caf80c69ce9a420d1473cb8a42d185c"
    sha256 cellar: :any,                 arm64_sonoma:  "5f9c8463f210212410667749247b871e13862415e1775f0e8354bd78e3635aac"
    sha256 cellar: :any,                 arm64_ventura: "7b28e75a6302ca0d653bc8336b906099878c3eb9a5d5b8c6eba3a94c18b39fd1"
    sha256 cellar: :any,                 sonoma:        "ef00a2f81cd5ac604e9c5332bdae8f2023e5fe60baa27b7d4fa29c2a56c503c2"
    sha256 cellar: :any,                 ventura:       "64a8fe12df9aee952bf718cbffd78c9acc6c184d8f6b493005438268a89debde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfc69c20b08f9f115be99e606de55bfbe53a3d69ce9a98128a5e2779533d73c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1ab2fdcf5877b8cf902f904dd5242886fd35c6d6dbdd1e8a22daf0698169a5"
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