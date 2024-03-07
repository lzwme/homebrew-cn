class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.4.1.tar.gz"
  sha256 "63c12a6a32a8e364f34f049d8b2477f4656021418f08b8d6b462be0ed3be3ac3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href\s*?=.*?xa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4faf66bc33b40db687358b44c1e3e20c1c6c0bb4d5b524a3cce3071907fb573e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca7bd74aa55cd1f8ac78ae44ecb698c2c79e3226aea4c5c59a24bf9677c0ba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15866623bc504d49b48f87805ce45b3812b0cf1e063a144d9c41ba967cd26f70"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd9d22c1fce31ad677470ef11937c660ed9ff4c852b57e232f1b09cd1ad19d38"
    sha256 cellar: :any_skip_relocation, ventura:        "e7aa2f3a2f025247bf99f94effbaac96b06949b604baa03d8777160cacb782d5"
    sha256 cellar: :any_skip_relocation, monterey:       "52344939bcd8aa7e47a27f2bce0b0f2b0f4d94145dd5bd1ae11a01bcf513e5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e35f6c603bbc9e5a84d41c3b9980f572989c8573139ff3438e36304745a5950"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end