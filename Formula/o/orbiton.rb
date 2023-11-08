class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://ghproxy.com/https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.5.tar.gz"
  sha256 "c53f28c5f2293e29e9bd4f3346375601c516eab3e3ec5f4c57e72dddf51e392a"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c10c42fe89c26e9fbff8d1c5d74ca37e8b227964b1f0bef6b01c293f64775988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b7faf5b8f4344bbbda99bceeacf2b9b872086626f169a80fec09c068444ef08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98adedc4f4b51ca33f000955374644bfb5550e876541ffa62c6b0945e61a19c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f01cd28fc1fcad25341a7232c45011ce3ccb279a0fcc567adc1d92c3bddf003"
    sha256 cellar: :any_skip_relocation, ventura:        "6b6b8e9eb8134dba6908b8fa8fb5f9dd560a74d8b184289e8a01abf94337cb4e"
    sha256 cellar: :any_skip_relocation, monterey:       "be284569fbd3c6b3952cbf37df2cf211ef8998614e4a5ecf03a4335853bd9095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe8fd87290e752383d9d3ec6f3a6a7708043183cd9e91acfc460fb28879b39e"
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