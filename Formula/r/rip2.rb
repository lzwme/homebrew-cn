class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https:github.comMilesCranmerrip2"
  url "https:github.comMilesCranmerrip2archiverefstagsv0.9.2.tar.gz"
  sha256 "1a2c54f04f5045de48553d4a81c359f3d5e0ed9ef6aa875185f43765533d2f15"
  license "GPL-3.0-or-later"
  head "https:github.comMilesCranmerrip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79cdf7da64b66458ae788d918224a2faf4e8e8f55733a278cc680aca7f5ffea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db8e496f0a80e786e14d9560357ec431075e413a1615e88c12fe4122dfdac591"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0093b04b01751dd9c6ba97e92507b96c44faade8cd91ccf5162792d67b301097"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d6b86d8c27a454a0efb919c9ee13b0d00c9d0a16891d2bb8e322029cda4faf"
    sha256 cellar: :any_skip_relocation, ventura:       "2ffa51a96b30d2fcd2a683fa325236934526873aa747c409ddfb90b7381113c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d660c554881637f34f86db907be00282c05d644cd45939ba3a0645decce5519"
  end

  depends_on "rust" => :build

  conflicts_with "rm-improved", because: "both install `rip` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rip", "completions")
    (share"elvishlibrip.elv").write Utils.safe_popen_read(bin"rip", "completions", "elvish")
    (share"powershellcompletions_rip.ps1").write Utils.safe_popen_read(bin"rip", "completions", "powershell")
    (share"nucompletionsrip.nu").write Utils.safe_popen_read(bin"rip", "completions", "nushell")
  end

  test do
    # Create a test file and verify rip can delete it
    test_file = testpath"test.txt"
    touch test_file
    system bin"rip", "--graveyard", testpath"graveyard", test_file.to_s
    assert_path_exists testpath"graveyard"
    refute_path_exists test_file
  end
end