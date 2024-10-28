class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.1.tar.gz"
  sha256 "fc881e6d5d7686d98026bcd3b99531a010bd6b787a01fb239b0d766668a2eee3"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9afb7b0d7798b0f0985a43ab96e3ba29dd650bbd5c1313d9c6df879697b1446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9afb7b0d7798b0f0985a43ab96e3ba29dd650bbd5c1313d9c6df879697b1446"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9afb7b0d7798b0f0985a43ab96e3ba29dd650bbd5c1313d9c6df879697b1446"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10f4fe0fbadfcce36d9022e4a92ab01da8516036d442af869f3774489667527"
    sha256 cellar: :any_skip_relocation, ventura:       "b10f4fe0fbadfcce36d9022e4a92ab01da8516036d442af869f3774489667527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b501c07c240528b38b5c7f9f98182c233d072672e3782f68308dbca69d143dfa"
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