class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https:jbang.dev"
  url "https:github.comjbangdevjbangreleasesdownloadv0.124.0jbang-0.124.0.zip"
  sha256 "0b9957ad86ef59d33f248044e1b4bdc6a878426beb2819bcc0850fa4807453ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00c4b7ce3c44da1cc134dfc91ed7ec5149ef0672a2679fb34467abcb70e87a2e"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}binjbang", ^abs_jbang_dir=.*, "abs_jbang_dir=#{libexec}bin"
    bin.install_symlink libexec"binjbang"
  end

  test do
    system bin"jbang", "init", "--template=cli", testpath"hello.java"
    assert_match "hello made with jbang", (testpath"hello.java").read
    assert_match version.to_s, shell_output("#{bin}jbang --version 2>&1")
  end
end