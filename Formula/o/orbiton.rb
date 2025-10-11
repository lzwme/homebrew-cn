class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://ghfast.top/https://github.com/xyproto/orbiton/archive/refs/tags/v2.70.0.tar.gz"
  sha256 "ab940369469a534311466621f8e65f712446aadc6a4016e9d912b68d420d5371"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b004a96e55d586d3d04b30ae885a480d7ec761cf3700f5d58d7fd070281e9d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a82a8f1a94b850d4cf0a5377baa22d91788e15b42b62e7f93c841af1366a50a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a82a8f1a94b850d4cf0a5377baa22d91788e15b42b62e7f93c841af1366a50a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a82a8f1a94b850d4cf0a5377baa22d91788e15b42b62e7f93c841af1366a50a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e078c56ab83f6e1f1cf7d01408a7cc9d0e99414e6eb78dc8ad363982f316c44b"
    sha256 cellar: :any_skip_relocation, ventura:       "e078c56ab83f6e1f1cf7d01408a7cc9d0e99414e6eb78dc8ad363982f316c44b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a1a3b94fb7df86fac0e144d73ed999da8dd2691ccdcea1c233c5be3cec43c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86dc3a94ff2a6ccfb2c91f748711bdcdfe02de071f52f96d3c4fb5813d242dd7"
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