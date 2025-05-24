class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https:github.comVirusTotalyara"
  url "https:github.comVirusTotalyaraarchiverefstagsv4.5.3.tar.gz"
  sha256 "59323f69b55615fda3ee863062370b90a09016616da660ae00c7f84adf12238e"
  license "BSD-3-Clause"
  head "https:github.comVirusTotalyara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b62064cf00cdd17ce560d6e30fe63ed1f579ca1c36086d4570efe5d0f883ce03"
    sha256 cellar: :any,                 arm64_sonoma:  "c6b8958c39be86d2725762e90351c201cd8871ddd82ce644a6c710c12ea4bfee"
    sha256 cellar: :any,                 arm64_ventura: "539320e0184228b30f87327688d15177c02cba3b9d1716258b20a2280d79346a"
    sha256 cellar: :any,                 sonoma:        "29a008eff0db0a821afdec5aa42dd87bdede577716a67710882fb98334ff15c1"
    sha256 cellar: :any,                 ventura:       "3adb6f8b228b1b847e95d3ce5ccfc35774640b7acb6e30e7290041f43f701af0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8eb9ad293a10c61ddac7d995e94536d20ae6ba19a07312ed608d160d338211e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d90c1eb58395126594a0ab2f7970562ab7dae1c3b03352d45e9b3bf836c852a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system ".bootstrap.sh"
    system ".configure", "--disable-silent-rules",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto",
                          *std_configure_args
    system "make", "install"
  end

  test do
    rules = testpath"commodore.yara"
    rules.write <<~YARA
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    YARA

    program = testpath"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}yara #{rules} #{program}").strip
  end
end