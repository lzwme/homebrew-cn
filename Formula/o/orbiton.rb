class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.8.tar.gz"
  sha256 "e7124e04dfe1ec77c6a0dac0a2e7de7b0478c7c3513a6438df22be740b5a5c2d"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "041526955a9545cbd3455741d99e27114b08d8df21300b000927a5952e25e957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041526955a9545cbd3455741d99e27114b08d8df21300b000927a5952e25e957"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "041526955a9545cbd3455741d99e27114b08d8df21300b000927a5952e25e957"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f330f11f8c361ae3f328d2bbba0ccc7483f6f6d741069f06e70477d00ab934f"
    sha256 cellar: :any_skip_relocation, ventura:       "2f330f11f8c361ae3f328d2bbba0ccc7483f6f6d741069f06e70477d00ab934f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b621abd3a77bab62d184951c0fba164f32946e144573851f2224f3470dd02d13"
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