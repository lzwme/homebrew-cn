class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://ghproxy.com/https://github.com/jbangdev/jbang/releases/download/v0.110.0/jbang-0.110.0.zip"
  sha256 "693376d102dd372f5590b5cda4eaca7bfb32424af51b20d6944b857b628a33fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50782f3cf7fc385a6fcb916ded33bc0aa353e15fcfd456151769921bebb4bd5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50782f3cf7fc385a6fcb916ded33bc0aa353e15fcfd456151769921bebb4bd5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50782f3cf7fc385a6fcb916ded33bc0aa353e15fcfd456151769921bebb4bd5b"
    sha256 cellar: :any_skip_relocation, ventura:        "50782f3cf7fc385a6fcb916ded33bc0aa353e15fcfd456151769921bebb4bd5b"
    sha256 cellar: :any_skip_relocation, monterey:       "50782f3cf7fc385a6fcb916ded33bc0aa353e15fcfd456151769921bebb4bd5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "50782f3cf7fc385a6fcb916ded33bc0aa353e15fcfd456151769921bebb4bd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f446acd0dbbb647bc95c09615f342eb7af51591fce191c88a00f54ff5ece4d6f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end