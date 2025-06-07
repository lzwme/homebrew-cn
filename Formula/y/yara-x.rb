class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https:virustotal.github.ioyara-x"
  url "https:github.comVirusTotalyara-xarchiverefstagsv1.0.1.tar.gz"
  sha256 "6898edc7e42681191ef84df9f910e3c1761cc446c0e9dc026a340f6f1e888f5d"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27e9fd18203799c4020379c11e27acdff15967d13f1fd965e5e6069295c6b1f3"
    sha256 cellar: :any,                 arm64_sonoma:  "364d198aa104d6c1468426046955136ecf4ef8b2dc12baf43ab3b806e5823a31"
    sha256 cellar: :any,                 arm64_ventura: "703d1c3bbc97c33b18d33fff791bc95ca2307c3156149511147ce1b8ab575605"
    sha256 cellar: :any,                 sonoma:        "3325d09ec22a8039943c25efad26b11337532aa78e363a76f0224d5e22234b45"
    sha256 cellar: :any,                 ventura:       "9844c3ba2b8b46702566f1e4c56b6c6267cfe44859380ff1eaf8ee19cbc7cf49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41335890bfd730f2650f9b8146042e582a65516beaaae15f2f609be0c7f1613f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9db0a8c28d22b4934c8a9acc4ab5dcb4951f962f705604daf8c57ce390c2d3"
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