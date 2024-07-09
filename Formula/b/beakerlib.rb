class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https:github.combeakerlibbeakerlib"
  url "https:github.combeakerlibbeakerlibarchiverefstags1.31.1.tar.gz"
  sha256 "5557f0226311d2cf234a4f5cd3edbf99f1e88c7f10210c5c0c17b43c220b6c81"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6a9bd8972db1eabd9348ed19150ffbe0264123f9e8a1b8085854e665a89d745"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b99bdf60bcf892e0b978a74c0adcaffb6aef396356c27cae96d6884c335f8e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5440a846295df9f114b82e8d31083ccbd3dfd26728b86be20bd527c09f919e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c75b9044b36cd16335dfb007bb7810e862bd5754a9c60138a63808e646d5126"
    sha256 cellar: :any_skip_relocation, ventura:        "2ecd3250e3f5e27ccfed3a03277522467013ce4c04a475faab462a28d87bd9ca"
    sha256 cellar: :any_skip_relocation, monterey:       "6ceccc24b482bbd69e3b47ca84192a1c418f6cf4e5317fdaa1997fe6c9b13d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a30d3953941414e616984cdd98012e0db0efdfa5630293cdbbf89292bf5eb32d"
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