class Biodiff < Formula
  desc "Hex diff viewer using alignment algorithms from biology"
  homepage "https:github.com8051Enthusiastbiodiff"
  url "https:github.com8051Enthusiastbiodiff.git",
      tag:      "v1.2.0",
      revision: "36ff3e726bbb73946e744e34c954fa153be3870b"
  license "MIT"
  head "https:github.com8051Enthusiastbiodiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec4047633c531dbccc3b1c976e74125bf24f2ada736f4fe3bbcbf271fa293d81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0ebee830c841ca69838ae18ca17ddc48861ac3ffd0be46a1e9d8201751c6b51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b68de01574795be9461d612617a80436fc4357760d0f44bdccf2cf559e8e709"
    sha256 cellar: :any_skip_relocation, sonoma:         "aca2b43d6be9590cab49175e11ef662c3b1792659e4d380512ac0c22a8e7eb34"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9ae6e70838753e8ec056fb43fa264ff57ae8c3a98e2344bc2a5a79cd752057"
    sha256 cellar: :any_skip_relocation, monterey:       "fa2ba44a2968383e4f301223b9bb00f1a0abe69622946052499be19bb797a84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7692cfd54720297a8f1ff48eb03e6f2b2f1d2cf5963457ccce5c2e22354e5017"
  end

  depends_on "cmake" => :build # for biodiff-wfa2-sys
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    begin
      (testpath"file1").write "foo"
      (testpath"file2").write "bar"

      r, w, pid = PTY.spawn "#{bin}biodiff file1 file2"
      sleep 1
      w.write "q"
      assert_match "unaligned            file1  | unaligned            file2", r.read

      assert_match version.to_s, shell_output("#{bin}biodiff --version")
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end