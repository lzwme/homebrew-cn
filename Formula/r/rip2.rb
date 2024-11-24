class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https:github.comMilesCranmerrip2"
  url "https:github.comMilesCranmerrip2archiverefstagsv0.9.0.tar.gz"
  sha256 "e8519e21877c8883f9f2a700036c53bce62b5ee0afaef47a12780999457e2633"
  license "GPL-3.0-or-later"
  head "https:github.comMilesCranmerrip2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9fa277be23b426860e37d9658620d46311bc5b0065fa7c232f2ab769f779d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500d7e065612b003b3e31d5f91f43aa5995c3afad06b6533936a5997b0f62cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de13d5079f302c386719362cfb65011110b3a8faa7c5845af68a8b2a69159b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8fa85b00767c7def700c5b647df482986260e2f7e7b5903a8fe26f53e95092e"
    sha256 cellar: :any_skip_relocation, ventura:       "48d407f40d865a6637c32bd7f2f497364ae490fcda84876a9a25920a7d9b448f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1457c0bf5d20f130a3456f408e935d7815641b9acf470b9cb7bcfbc4a01e8965"
  end

  depends_on "rust" => :build

  conflicts_with "rm-improved", because: "both install `rip` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rip", "completions", base_name: "rip")
    (share"elvishlibrip.elv").write Utils.safe_popen_read(bin"rip", "completions", "elvish")
    (share"powershellcompletions_rip.ps1").write Utils.safe_popen_read(bin"rip", "completions", "powershell")
    (share"nucompletionsrip.nu").write Utils.safe_popen_read(bin"rip", "completions", "nushell")
  end

  test do
    # Create a test file and verify rip can delete it
    test_file = testpath"test.txt"
    touch test_file
    system bin"rip", "--graveyard", testpath"graveyard", test_file.to_s
    assert_predicate testpath"graveyard", :exist?
    refute_predicate test_file, :exist?
  end
end