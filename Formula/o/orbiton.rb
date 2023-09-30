class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://ghproxy.com/https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.1.tar.gz"
  sha256 "2d5bf171d9d18357d2ef6e6ed41d01a50c79dc3dd58de02ad4cc88b172e02b89"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caf42d4abe7f0911c34fdd2c444d6b09c4634128fd6aef3db2ea80fc045df54c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a575c127302a35e056fb74d68fee6623efed4697202373c89e531ff812fe9a37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc771adad16f96604b47901aa21bcc660e986baf167e0d43a9c37675ae16588"
    sha256 cellar: :any_skip_relocation, sonoma:         "488efc720ae0138e35ab24314aa8be0330d0cdda016322343ad96e296e5df74d"
    sha256 cellar: :any_skip_relocation, ventura:        "852d3a3e611b3015c73e15808dd9d2284dd1df663042cdb1672dedb7295fcabb"
    sha256 cellar: :any_skip_relocation, monterey:       "603d426cfd50d48a4c9f676eb8cacaea99fadb1731969a383bca1f12c4979b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ff7dd39cb9a007124e2609c642a531944132f2b51f13ee30fb3fc7cfc4c2447"
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
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end