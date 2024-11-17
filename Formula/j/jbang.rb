class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https:jbang.dev"
  url "https:github.comjbangdevjbangreleasesdownloadv0.121.0jbang-0.121.0.zip"
  sha256 "4ffa57f26c713cde084b728a64b1c79b74465e6b8e043175e3b6c364377613c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12f2a604b5561b8a854ed43337a636d2f48e25a28dde8d950e5f13e01d27eb37"
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