class Miruo < Formula
  desc "Pretty-print TCP session monitor/analyzer"
  homepage "https://github.com/KLab/miruo/"
  url "https://ghfast.top/https://github.com/KLab/miruo/archive/refs/tags/0.9.6b.tar.gz"
  version "0.9.6b"
  sha256 "0b31a5bde5b0e92a245611a8e671cec3d330686316691daeb1de76360d2fa5f1"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d2bbd65942dc88b12e85715f157eaf8f2f76976616a11d5177bb118a02515d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "07c790261ecabfbdd53bd0bec573d4e93148f906229f8e3e2fba8a6da213794e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55dcd6ea73bec9f341df715534d5bd504d048a8bee3f8d5627302cb734840f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9bb44cd7fe123593bf3e89da14aa5b2987bf1b616ae671bfa5d7e1d9adb992b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a56112e32e6ba542f3679e87d247d10850c74ad6e9d7f82504a40caa0737de1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd45391af46ccd1a166e139e2aa6020e0e75999a094e5e4a4eabb8ca5056fc97"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8b65b937c59f9662343515dd8fb0450ba9e9828ef00cb4829b219c8bf379be9"
    sha256 cellar: :any_skip_relocation, ventura:        "de0e2a37948da0d8fa4a0b34e89ee1b5511fdc85d3ec7037b66f39aba60df795"
    sha256 cellar: :any_skip_relocation, monterey:       "cd83d74247835df4ef5036c68c8d93539ef3b2eac56ffc839334d1f95c557e61"
    sha256 cellar: :any_skip_relocation, big_sur:        "61fbf984ade171a70ae80af4695a78ed35331a143cdc12ddf4440fee74889807"
    sha256 cellar: :any_skip_relocation, catalina:       "044456429802d6f6d8ba2a8d00547e0e0695e99edd1cceb1af29e70eb004d13f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "981815843bbf557cc108baa34c2dc61b101df2fc14b23451c732102468527f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f079697d80cff4b00726c8c149727a4a19c3db789e417692f470175ad9f24f25"
  end

  uses_from_macos "libpcap"

  def install
    # https://github.com/KLab/miruo/pull/19
    inreplace "miruo.h", "#include<stdlib.h>", "#include<stdlib.h>\n#include<ctype.h>"
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
    ]
    args << "--with-libpcap=#{MacOS.sdk_path}/usr" if OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"dummy.pcap").write "\xd4\xc3\xb2\xa1\x02\x00\x04\x00\x00\x00\x00\x00" \
                                  "\x00\x00\x00\x00\xff\xff\x00\x00\x01\x00\x00\x00"
    system "#{sbin}/miruo", "--file=dummy.pcap"
  end
end