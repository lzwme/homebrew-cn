class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.0.tar.gz"
  sha256 "40662eccfabb55bd13269378ed59d32b84cbaba5c92170c2c43d9a4056c27a46"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb99e2a1fa789512315dcddb218992063846d17c0c6a7f1be573e251005e887d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb99e2a1fa789512315dcddb218992063846d17c0c6a7f1be573e251005e887d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb99e2a1fa789512315dcddb218992063846d17c0c6a7f1be573e251005e887d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb7a37b4dfb9fe9d8b458eb68c986a89fec63b63007c3db05f5a74b764e81c45"
    sha256 cellar: :any_skip_relocation, ventura:       "fb7a37b4dfb9fe9d8b458eb68c986a89fec63b63007c3db05f5a74b764e81c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56b212c00bb9a1c0c68712fde9687d856ffe00ee8a4ad4010e182234d7e2d98c"
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