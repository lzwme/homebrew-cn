class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.18.01.tar.gz"
  sha256 "30465ee60a32d9018d0de8a78cfeaa576e869b6e6db87e3628d0704dbe61b561"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "347b26278e00b49840694f7851de630fb501a8ec1765beaa2329820ff6e88d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c1378eab906fd44b1bf867a0dc65a21d64fdaff19e3aa2a804eacd51d926c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42642dd1da2f18e06d6f7aa1aa4858b6a1c6f5cef4233fd413ccfd1ee22044f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4cf3e991148451b73d58a9ca02e0551f58a1864d7d0f2146f25072b561b19b2"
    sha256 cellar: :any_skip_relocation, ventura:        "015c819ae2be4b20d47ca3fc3bc48e4cd60bf27c299ebfc9ca1c08e0a673e306"
    sha256 cellar: :any_skip_relocation, monterey:       "031f7a58dc9e2c441b59bcbe55196210f6b807437e9a812eae60154ce59c30a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c2735f90e6bf70d7163151d445c4c0546920f457cf7453cf564fae2284f370"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "usr", prefix
      s.change_make_var! "BASHDIR", prefix"etcbash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completionstress-ng"
  end

  test do
    output = shell_output("#{bin}stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end