class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https:github.comMilesCranmerrip2"
  url "https:github.comMilesCranmerrip2archiverefstagsv0.9.0.tar.gz"
  sha256 "e8519e21877c8883f9f2a700036c53bce62b5ee0afaef47a12780999457e2633"
  license "GPL-3.0-or-later"
  head "https:github.comMilesCranmerrip2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a4d759abfa23e78e1cd6afdd0028703fdc0ab458b236a4bae9a49efd6c0cc83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f460615657d60899f49dc1213c930fa141966d10f127c3986cc15f01f930d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bdb15ca69ebc0004751ec3f2757fbd14ddef1f90dec9bb570277dbf45b3f777"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a7c61b77e9ee7fc0c1d1ee2749f743b0ffcee9dc733e6ad21888fc526914cc"
    sha256 cellar: :any_skip_relocation, ventura:       "4558e844f0c8e1e59dc51830319e4b1844801cc9db0c49f57e9ce1182157fe39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e49acfea663691ff2881a5f09ada40b93b83948f96c50466d74f2d1401549e"
  end

  depends_on "rust" => :build

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
    assert_predicate testpath"graveyard", :exist?
    refute_predicate test_file, :exist?
  end
end