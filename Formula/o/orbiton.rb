class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.67.0.tar.gz"
  sha256 "5d95a755ab48b1b05e2c2a7fc475e0c9875ee90c0441d0be3a8d4b85f2db284a"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ae3661705ff00ced573820daad425e230be7bd233d2f1ebba7f77e72cfbebb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae3661705ff00ced573820daad425e230be7bd233d2f1ebba7f77e72cfbebb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ae3661705ff00ced573820daad425e230be7bd233d2f1ebba7f77e72cfbebb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b1b58492f2c5bbd4269f4a87b493802a67d93c5c26549f73ee21453308c36f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4b1b58492f2c5bbd4269f4a87b493802a67d93c5c26549f73ee21453308c36f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4b1b58492f2c5bbd4269f4a87b493802a67d93c5c26549f73ee21453308c36f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f984551a5d1562803675401e72b1afffb6ea36464fa2a8544490e11362508b6"
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