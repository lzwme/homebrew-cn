class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.17.05.tar.gz"
  sha256 "48964a0de5838acfed5c78d78d5f4a1d86974883d5537ccc55df019a0186a1b5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "704e26145d2b9762de0c4009cccd2a76f549934dcb7fd2570b711472918f0bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03c35056b15ebbb55df78471e87c7786b29c4d5e1785808b1cab969c7449b443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4520e471e1629aade39af86a069660bd5fe00d6f7a21bcb25d2557b1668aef8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c3e7d1944701553b7c4c488739408a47c062b8f4a83101f66123a7b28d64c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "69868c98a2ed17d00011ba4d09adacdf2742fa009b09b7b9b567b1c5af243882"
    sha256 cellar: :any_skip_relocation, monterey:       "87edd5a9acd283d31679227a14ffbe70d9b151f022c1f4926f83e2f85f46e17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a7f6148676cec901923910e656e14a4354954bddd48975f97757e44f4b460e"
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