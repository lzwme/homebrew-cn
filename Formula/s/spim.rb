class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.net/"
  url "https://ghfast.top/https://github.com/billsix/spimulator/archive/6cb6a0828c806024b7f72c86173ced415abe3d68.tar.gz"
  version "9.1.24"
  sha256 "69d6fe14c0821c957ec72b2c15b9371c74b22fccc731c1502aac6a571f7ca98b"
  license "BSD-3-Clause"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "bfa493c9c80e365fe5721ab6226f244528ab8cebfe6dca8899579d1ca8eedf1d"
    sha256 arm64_tahoe:       "fecdc6101845049336385f58800dc0c996698568336e6d3165f3c673f18f8f7c"
    sha256 arm64_sequoia:     "0ee17f876d15fd6b88452e7d19f2c1a182ce248aef26c1182deee6ba30538d45"
    sha256 arm64_linux:       "db5606732a7bb6086e650d673c3b4c22366a4a4cf6cd777a0681f16b18bd5793"
    sha256 x86_64_linux:      "c1b178dd6ac7d8be0bb3fc1c5cde0fa5da7ae94159ff69013a050fd0051676ba"
  end

  deprecate! date: "2026-10-17", because: "does not have a checksummed source"
  disable! date: "2027-04-17", because: "does not have a checksummed source"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}"
      system "make", "install-man", "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output(bin/"spim", "print_symbols")
  end
end