class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https:github.combeakerlibbeakerlib"
  url "https:github.combeakerlibbeakerlibarchiverefstags1.31.tar.gz"
  sha256 "8aeba4c8174c31b86241d88138e61d541adaf07128d8233be2dd4e199c61f7d2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "180179db23b4fde782658c3d2a79862fe78c96cf83f49c1207b8b0fc50e1995e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b3d212a4f5eb4dca27f8fd04b85256cd02ebb95d84bbd0d19a9c00de9fd22ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "072d47eff2232e98edb099c1183edee92ee7780ba5091d2530b1d1f4469f330c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f0c1ae49689a0b7deb5a4b1d535985b177a8ef92e09ee34b82914eecc876817"
    sha256 cellar: :any_skip_relocation, ventura:        "7a48fc04ae1875fb6a2f98e64c472bf4b0ddbe56bc1700643bf76247e91aeb15"
    sha256 cellar: :any_skip_relocation, monterey:       "6b73b5b96c04dc90ae79ada4c7d97564719d9ead2161e0ebe10563ac54ff35d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c0f368852109144b69d1bcfcbc1f74bf73c1ab450483787795f2ff34e2e905"
  end

  on_macos do
    # Fix `readlink`
    depends_on "coreutils"
    depends_on "gnu-getopt"
  end

  def install
    make_args = [
      "DD=#{prefix}",
    ]
    make_args << "GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}getopt" if OS.mac?
    make_args << "READLINK_CMD=#{Formula["coreutils"].opt_bin}greadlink" if OS.mac?
    system "make", *make_args, "install"
  end

  test do
    (testpath"test.sh").write <<~EOS
      #!usrbinenv bash
      source #{share}beakerlibbeakerlib.sh || exit 1
      rlJournalStart
        rlPhaseStartTest
          rlPass "All works"
        rlPhaseEnd
      rlJournalEnd
    EOS
    expected_journal = \[\s*PASS\s*\]\s*::\s*All works
    ENV["BEAKERLIB_DIR"] = testpath
    system "bash", "#{testpath}test.sh"
    assert_match expected_journal, File.read(testpath"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath"TestResults")
  end
end