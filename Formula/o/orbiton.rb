class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://ghfast.top/https://github.com/xyproto/orbiton/archive/refs/tags/v2.71.0.tar.gz"
  sha256 "3f3ac727160a816107b6414b7f9bb2783a34779111fcd380004e0bda84bf2676"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5f266ad255f6dd591f560a632219c9689778a72037fd8fc2092a5d97dbc1eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5f266ad255f6dd591f560a632219c9689778a72037fd8fc2092a5d97dbc1eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c5f266ad255f6dd591f560a632219c9689778a72037fd8fc2092a5d97dbc1eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf60f587ea599ca17bde9060acecc9bbf02cfe4e258986efb751e135d0e30466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d98641778105fd2aaa1e79a536e357fea37eda4cad1ce343b5443bfd395330ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c695da2245cd315eab15fd53d8fd6122355ed0e0b92a97c7d79e4f18599c347"
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