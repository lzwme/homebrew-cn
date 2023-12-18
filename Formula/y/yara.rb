class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https:github.comVirusTotalyara"
  url "https:github.comVirusTotalyaraarchiverefstagsv4.3.2.tar.gz"
  sha256 "a9587a813dc00ac8cdcfd6646d7f1c172f730cda8046ce849dfea7d3f6600b15"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comVirusTotalyara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89b72648e12c3afc9c59b8f20f604f8237d372727de03113724303bb43a434ee"
    sha256 cellar: :any,                 arm64_ventura:  "ef3e280e87b7607f3eea94508e8fa9a628009f60676fccdce22340809a70cb36"
    sha256 cellar: :any,                 arm64_monterey: "3ca150ac17fc10bed27eff89094ec9ebd2e70abed402fc091874f8677e7abff2"
    sha256 cellar: :any,                 arm64_big_sur:  "02ba0c77f44d762e4fb0fa670549be58a67269eb0af48aa8155e40b8361d40c4"
    sha256 cellar: :any,                 sonoma:         "8745ef9320f293665d2ff588652195fd95bf644a2bf25c4f2218e82636f526c7"
    sha256 cellar: :any,                 ventura:        "41bb56c91fb8eaf533d7e8786d95aee23c94f71ae95ef9a241e0e5b87497cba7"
    sha256 cellar: :any,                 monterey:       "5a1ac4f8d742aa6046755a14a08b57a7c4c1aa1ee2f27127ec45a7aef05ffde6"
    sha256 cellar: :any,                 big_sur:        "26ede9206b84edfb30d9c0554211e3c683722bd0bb917b639f7a05f652a51104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05503944946a647cf21c2c92a9ceaa9e6559e5050773b89146de5c8aaa847105"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system ".bootstrap.sh"
    system ".configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto"
    system "make", "install"
  end

  test do
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

    assert_equal "chrout #{program}", shell_output("#{bin}yara #{rules} #{program}").strip
  end
end