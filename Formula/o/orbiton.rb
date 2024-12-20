class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https:roboticoverlords.orgorbiton"
  url "https:github.comxyprotoorbitonarchiverefstagsv2.68.6.tar.gz"
  sha256 "36510204d12f607dff6952ab80ee4fcad1cd5be873a41d2c8006a47ea5d9ebe9"
  license "BSD-3-Clause"
  head "https:github.comxyprotoorbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c2c8b41f557ae3d06cc617216101bda2d90013125e9f2e09a6f97d58f27c26d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2c8b41f557ae3d06cc617216101bda2d90013125e9f2e09a6f97d58f27c26d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c2c8b41f557ae3d06cc617216101bda2d90013125e9f2e09a6f97d58f27c26d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea8f6b973be280b6c8e836d3856fd06e8d890eca7a7739f86167dbb5e23447f"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea8f6b973be280b6c8e836d3856fd06e8d890eca7a7739f86167dbb5e23447f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582f8e9e4afcbaa6a5336e60b59bc7ab4dedc6e35dd151cbaa5efe2eb6f2d786"
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