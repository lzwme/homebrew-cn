class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.2.tar.gz"
  sha256 "3facf3b4f066d9a6ba33a969fd0b540c224bdfdfde1d4abe3fcc70e072dbee1b"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee787f8183688c19bf756ea0190f2f985c2c7a33631252946e3cbeb513eb89f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee787f8183688c19bf756ea0190f2f985c2c7a33631252946e3cbeb513eb89f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee787f8183688c19bf756ea0190f2f985c2c7a33631252946e3cbeb513eb89f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1930aebb80236b81a67d610e52b07ebc0a21521991d7751f30c78f8b3183e57a"
    sha256 cellar: :any_skip_relocation, ventura:       "1930aebb80236b81a67d610e52b07ebc0a21521991d7751f30c78f8b3183e57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9a102525b3a251778eef1e5a11b216a596a197bee418fa311f463cffce5a37"
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