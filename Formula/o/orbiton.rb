class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://ghfast.top/https://github.com/xyproto/orbiton/archive/refs/tags/v2.72.0.tar.gz"
  sha256 "eb0e61a0c032f5d41281dd42508e64fc653491103d9e32999c0cc621a4e44dff"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0631d59e263b0c1d433da61d12abf769ea8264231f73cc70bfe97741ca77724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0631d59e263b0c1d433da61d12abf769ea8264231f73cc70bfe97741ca77724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0631d59e263b0c1d433da61d12abf769ea8264231f73cc70bfe97741ca77724"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb7d378d33b6fed4e1ef4c9be378a0a028419c895387e393a849a5320bcd1cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158b3a4e1cefc8d623a95354743b8fd04d6c670cbd0b645c90f2939e18589192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c2cc7cfa57f9fd08a939bc587d6bde88354dea9bcaedc74113561b3677499f"
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