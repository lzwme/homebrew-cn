class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://ghfast.top/https://github.com/beakerlib/beakerlib/archive/refs/tags/1.33.1.tar.gz"
  sha256 "a18cecff44e3f1a2982dd2810e712cea2ebdb9f7dad6e7fd11026ca8d340e284"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c98627853c190e4eacb3dfb72224cc303cae4a5f8a4354f1782a2968a3ad609e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88c7aa63a57d52cb1fab07a0aeb6c7019c65397c780740e82dd47d838af1426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa081f07b3f4d65c338ef022fdc26529ea953db88f068db7f10771fbd71e16f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a197a40cb531101f6d3be46fc87cd835bc7989d1be6a5063275544ef3a59aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a452286772868aa75d7100c4e19b3edbf74ae7fa8328c460676e34aecab83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4548bd4c493ebbf02fb4ce34dc3c930c849634c7d168fe2ea1ffd9aff816764"
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
    make_args << "GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt" if OS.mac?
    make_args << "READLINK_CMD=#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?
    system "make", *make_args, "install"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/usr/bin/env bash
      source #{share}/beakerlib/beakerlib.sh || exit 1
      rlJournalStart
        rlPhaseStartTest
          rlPass "All works"
        rlPhaseEnd
      rlJournalEnd
    SHELL
    expected_journal = /\[\s*PASS\s*\]\s*::\s*All works/
    ENV["BEAKERLIB_DIR"] = testpath
    system "bash", testpath/"test.sh"
    assert_match expected_journal, File.read(testpath/"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath/"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath/"TestResults")
  end
end