class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https:jbang.dev"
  url "https:github.comjbangdevjbangreleasesdownloadv0.117.1jbang-0.117.1.zip"
  sha256 "28b66273d5ff4057ed37a2dfda5b49b549768e8bed6e0ea335015eea8d28c67c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8c08677242b43228c1f04d9f8e0b7d0c2bdd17bd970b22551f47da9dc7680d6f"
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