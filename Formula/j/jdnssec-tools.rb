class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https:github.comdblackajdnssec-tools"
  url "https:github.comdblackajdnssec-toolsreleasesdownloadv0.19jdnssec-tools-0.19.tar.gz"
  sha256 "24bc5408e1fddd5788d372cd5ba14bd89c719910862b8d8d643f17639ab435e3"
  license "LGPL-2.1"
  head "https:github.comdblackajdnssec-tools.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a00ed674685e49c9580379c58152bece1eec574e53b81eaf7fbad84cc4be7be"
  end

  depends_on "openjdk"

  def install
    inreplace Dir["bin*"], basedir=.*, "basedir=#{libexec}"
    bin.install Dir["bin*"]
    bin.env_script_all_files libexec"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
    (libexec"lib").install Dir["lib*"]
  end

  test do
    (testpath"powerdns.com.key").write <<~EOS
      powerdns.com.   10773 IN  DNSKEY  257 3 8 (AwEAAb+pXOZWYQ8mv9WM5dFva8
      WU9jcIUdDuEjldbyfnkQxlrJC5zA EfhYhrea3SmIPmMTDimLqbh34SMTNPTUF+9+U1vp
      NfIRTFadqsmuU9F ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04
      Cx83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE 1LpnJIwcUpRU
      iuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW UbULpRail+Cr5Taj988HqX9Xdm
      6FjcP4Lbuds44U7U8du224Q8jTrZ 57Yvj4VDQKc=)
    EOS

    assert_match "D4C3D5552B8679FAEEBC317E5F048B614B2E5F607DC57F1553182D49AB2179F7",
      shell_output("#{bin}jdnssec-dstool -d 2 powerdns.com.key")
  end
end