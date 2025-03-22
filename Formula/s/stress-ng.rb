class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.18.11.tar.gz"
  sha256 "f4388c4d4d53172431cd77e029139ddd0dacb249ef59053dbc1f0c42188e3e35"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8bf0fe7c588bd60b0f9f0f8892a39341cefdba296ac3b0ea5569e2e8f4f5fdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28b53eb6acaf59f8ceadc71205b23ddb82c9688b9c38f3cbd0cefd1c94e9ae76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d171c294d8c0077f1bba9e74014bb77dfe150b596e8e7e53125f3a111086a59"
    sha256 cellar: :any_skip_relocation, sonoma:        "367e906d323f35bc994815639ef299c5349e5848251c714a68585f72acf5bcd3"
    sha256 cellar: :any_skip_relocation, ventura:       "d0a379aedaf756c727904b9842541b152a4356d84e4bc2a3750da8990a842541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce4280eefbaf979017f103ed8bc29614d9043b60e06d7c1c3d2f73c9387db1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddfaa29ce4bd87d311b044efda4dc4df9f297e69ca4fa1e7d443d5aeffcbc5e0"
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