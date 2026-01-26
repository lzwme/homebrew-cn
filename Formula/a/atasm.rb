class Atasm < Formula
  desc "Atari MAC/65 compatible assembler for Unix"
  homepage "https://sourceforge.net/projects/atasm/"
  url "https://ghfast.top/https://github.com/CycoPH/atasm/archive/refs/tags/V1.30.tar.gz"
  sha256 "c3ae8ea1f824e0ee65e123b33982572277207d1749bcd04da3af8f06af977db5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4624c43d42f400c186a54fd6000c7553737ffdf7021910b2f1b1656261a26d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ea6963c065e0e76560943ac765b1596013c8aa709c9d04e6a31f7d0c6c2e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6bfc5cf70bab6cd80ba13cb72ed949658f2d1a0ebff6ec8b01bee87c2783b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e1fba5d843e6ed3e7486f9d89e6ade88d6fe2ed9699a1c7795bed46688157b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "072eff0c34c17d737d83ecbd61f1351c934b88014a9b9677f70be1ab1cf7c876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a213cabdfe9445ab776d7588de31d43005c0389c41a114ae8c3b1ebcf82c08"
  end

  uses_from_macos "zlib"

  def install
    cd "src" do
      system "make"
      bin.install "atasm"
      inreplace "atasm.1.in", "%%DOCDIR%%", "#{HOMEBREW_PREFIX}/share/doc/atasm"
      man1.install "atasm.1.in" => "atasm.1"
    end
    doc.install "examples", Dir["docs/atasm.*"]
  end

  test do
    cd "#{doc}/examples" do
      system bin/"atasm", "-v", "test.m65", "-o/tmp/test.bin"
    end
  end
end