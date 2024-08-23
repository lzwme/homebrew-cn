class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.66.0.tar.gz"
  sha256 "e113e04da39f3a7d6c10fd34201b43286872f0dd1310c805d422cbebb14b845b"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "458deb8093cde2e05fde28fcf34bc4a8ab646b12c4337c6a605f89b8a52340b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "458deb8093cde2e05fde28fcf34bc4a8ab646b12c4337c6a605f89b8a52340b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458deb8093cde2e05fde28fcf34bc4a8ab646b12c4337c6a605f89b8a52340b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ee072431a0033acb78d71eb6ee9fcdf7bd77fce0eeb03257eb932befca0626"
    sha256 cellar: :any_skip_relocation, ventura:        "d8ee072431a0033acb78d71eb6ee9fcdf7bd77fce0eeb03257eb932befca0626"
    sha256 cellar: :any_skip_relocation, monterey:       "d8ee072431a0033acb78d71eb6ee9fcdf7bd77fce0eeb03257eb932befca0626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26e59f8a227fe2ae45554771816ec53b0b4b3081944e106d7e75e99d148bc40"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath"hello.txt").write "hello\n"
    copy_command = "#{bin}o --copy #{testpath}hello.txt"
    paste_command = "#{bin}o --paste #{testpath}hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath"hello.txt").read, (testpath"hello2.txt").read
  end
end