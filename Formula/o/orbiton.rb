class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.4.tar.gz"
  sha256 "1a159705513704de059f6edf9f40d3da7f0047ae70de00af6f7aa5a0a00d5140"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0549401d1b189b3e534aac4090f72a34de8aee51c0f23e57e3a2aaed07651a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0549401d1b189b3e534aac4090f72a34de8aee51c0f23e57e3a2aaed07651a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0549401d1b189b3e534aac4090f72a34de8aee51c0f23e57e3a2aaed07651a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e36d941d2cb01658a84e98589e0186875c124a4ea5e75710479906fa90e5411d"
    sha256 cellar: :any_skip_relocation, ventura:       "e36d941d2cb01658a84e98589e0186875c124a4ea5e75710479906fa90e5411d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3c19eb90695b862b510ea91b376bbb909e74662041c5177c02a7d6e05067b2"
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