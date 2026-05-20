class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://ghfast.top/https://github.com/xyproto/orbiton/archive/refs/tags/v2.74.2.tar.gz"
  sha256 "9596d633da001a1b1049ef51e03fdc98189befef35a8a674198da30d9e09d57b"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30cdb6da8b4c4dc368b91a6b4094c651757cef8221fb94b99743a880ff4e0fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30cdb6da8b4c4dc368b91a6b4094c651757cef8221fb94b99743a880ff4e0fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30cdb6da8b4c4dc368b91a6b4094c651757cef8221fb94b99743a880ff4e0fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1bfc5fa4c83ea62c8a16f70c005eeabb6396bda093ada558a4ab622caa7f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31e1f6cbf4b9ef4ba056428ca5558a695d9c9623277e323daa522ae77d19bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7214cc1beb5c3b75bfdc741bd7018f45dc53ae4be3e72632c8c66d6c629c5283"
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